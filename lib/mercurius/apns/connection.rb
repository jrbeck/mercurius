module APNS
  class Connection
    attr_reader :host, :port, :ssl

    def initialize(host, port, pem)
      @socket = TCPSocket.new host, port
      @ssl = OpenSSL::SSL::SSLSocket.new @socket, ssl_context_for_pem(pem)
    end

    def open
      @ssl.connect
    end

    def close
      @ssl.close
      @socket.close
    end

    def closed?
      @ssl.closed? && @socket.closed?
    end

    private

      def ssl_context_for_pem(pem)
        context = OpenSSL::SSL::SSLContext.new
        context.cert = OpenSSL::X509::Certificate.new(pem.data)
        context.key = OpenSSL::PKey::RSA.new(pem.data, pem.password)
        context
      end

  end
end