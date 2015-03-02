module APNS
  class Service
    include ActiveModel::Model

    MAX_NUMBER_OF_RETRIES = 3

    attr_accessor :host, :port, :pem
    attr_reader :connection, :attempts

    def initialize(*)
      super
      @host ||= APNS.host
      @port ||= APNS.port
      @pem  ||= APNS.pem
      @connection = APNS::Connection.new(@host, @port, @pem)
      @attempts = 0
    end

    def persist(&block)
      @_persistent = true
      yield
      @_persistent = false
      connection.close
    end

    def deliver(notification, *device_tokens)
      device_tokens = Array(device_tokens).flatten
      with_connection do |connection|
        device_tokens.each do |device_token|
          connection.write notification.pack(device_token)
        end
      end
    end

    private

      def persistent?
        @_persistent
      end

      def with_connection(&block)
        @attempts = 1

        begin
          connection.open if connection.closed?
          yield connection
        rescue StandardError, Errno::EPIPE => e
          raise TooManyRetriesError.new if too_many_retries?
          connection.close
          @attempts += 1
          retry
        end

        connection.close unless persistent?
      end

      def too_many_retries?
        @attempts >= MAX_NUMBER_OF_RETRIES
      end

  end
end
