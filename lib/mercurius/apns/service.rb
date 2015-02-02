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

    def send(*notifications)
      notifications = Array(notifications).flatten
      with_connection do |connection|
        notifications.each do |message|
          connection.ssl.write message.packaged_notification
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