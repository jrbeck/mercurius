module APNS
  HOSTS = {
    development: 'gateway.sandbox.push.apple.com',
    production: 'gateway.push.apple.com',
  }

  @host = ''
  @port = 2195
  @pem = nil

  class << self
    attr_accessor :host, :port, :pem

    def mode=(mode)
      raise InvalidApnsModeError.new unless HOSTS.include? mode.to_sym
      @host = HOSTS[mode.to_sym]
    end

  end

end
