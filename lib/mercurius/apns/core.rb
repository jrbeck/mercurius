require 'socket'
require 'openssl'
require 'json'

module APNS
  class Error < Exception; end
  class ConfigurationError < Error; end

  @host = 'gateway.sandbox.push.apple.com'
  @port = 2195
  @pem_path = nil
  @pem_password = nil
  @pem_data = nil

  @persistent = false
  @mutex = Mutex.new
  @retries = 3 # TODO: check if we really need this

  @sock = nil
  @ssl = nil

  class << self
    attr_accessor :host, :port, :pem_path, :pem_password, :pem_data
  end

  def self.start_persistence
    @persistent = true
  end

  def self.stop_persistence
    @persistent = false
    self.close_connection
  end

  def self.send_notification(device_token, message)
    notification = APNS::Notification.new(device_token, message)
    send_notifications([notification])
  end

  def self.send_notifications(notifications)
    @mutex.synchronize do
      with_connection do
        notifications.each do |n|
          @ssl.write(n.packaged_notification)
        end
      end
    end
  end

  def self.feedback
    sock, ssl = feedback_connection
    apns_feedback = []

    # read lines from the socket
    while line = ssl.read(38)
      line.strip!
      f = line.unpack('N1n1H140')
      apns_feedback << { timestamp: Time.at(f[0]), token: f[2] }
    end

    ssl.close
    sock.close

    apns_feedback
  end

protected

  def self.with_connection
    attempts = 1

    begin
      open_connection if connection_closed?
      yield
    rescue StandardError, Errno::EPIPE
      raise Error.new("Failed after #{@retries} attempts.") unless attempts < @retries
      close_connection
      attempts += 1
      retry
    end

    close_connection unless @persistent
  end

  def self.open_connection
    @sock = TCPSocket.new(self.host, self.port)
    @ssl = OpenSSL::SSL::SSLSocket.new(@sock, context)
    @ssl.connect
  end

  def self.close_connection
    @ssl.close
    @ssl = nil
    @sock.close
    @sock = nil
  end

  def self.connection_closed?
    @ssl.nil? || @sock.nil? || @ssl.closed? || @sock.closed?
  end

  def self.feedback_connection
    fhost = self.host.gsub('gateway','feedback')
    sock = TCPSocket.new(fhost, 2196)
    ssl = OpenSSL::SSL::SSLSocket.new(sock, context)
    ssl.connect
    return sock, ssl
  end

  def self.context
    context = OpenSSL::SSL::SSLContext.new
    context.cert = OpenSSL::X509::Certificate.new(pem_data)
    context.key = OpenSSL::PKey::RSA.new(pem_data, pem_password)
    context
  end

  def self.pem_data
    return @pem_data if @pem_data

    if @pem_path
      raise ConfigurationError.new('The specified PEM file does not exist.') unless File.exist?(@pem_path)
      @pem_data = File.read(@pem_path)
    else
      raise ConfigurationError.new('PEM not configured properly.')
    end
  end

end
