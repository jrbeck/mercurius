module APNS
  class Connection
    attr_reader :host, :port, :pem

    def initialize(host, port, pem)
      @host = host
      @port = port
      @pem = pem
    end

    def open
      @socket ||= TCPSocket.new host, port
      @ssl ||= OpenSSL::SSL::SSLSocket.new @socket, ssl_context_for_pem(pem)
      @ssl.connect
    end

    def close
      @ssl.close if @ssl
      @socket.close if @socket
    end

    def closed?
      (@ssl.nil? || @ssl.closed?) ||  (@socket.nil? || @socket.closed?)
    end

    def write(data)
      @ssl.write data
    end

    # def read()
    #   @ssl.read
    # end

    private

      def ssl_context_for_pem(pem)
        context = OpenSSL::SSL::SSLContext.new
        context.cert = OpenSSL::X509::Certificate.new(pem.data)
        context.key = OpenSSL::PKey::RSA.new(pem.data, pem.password)
        context
      end

  end
end
