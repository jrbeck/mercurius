module GCM
  class Service
    include ActiveModel::Model

    MAX_NUMBER_OF_RETRIES = 3
    MAX_DEVICES_AT_ONCE = 999

    attr_accessor :host, :key
    attr_reader :connection, :attempts

    def initialize(*)
      super
      @host ||= GCM.host
      @key  ||= GCM.key
      @connection = GCM::Connection.new(@host, @key)
      @attempts = 0
    end

    def deliver(notification, *device_tokens)
      result = GCM::Result.new(notification)
      device_tokens = Array(device_tokens).flatten
      device_tokens.each_slice(MAX_DEVICES_AT_ONCE) do |tokens|
        payload = notification.to_h.merge registration_ids: tokens
        result.process_response connection.write(payload), tokens
      end
      result
    end

    private

      def too_many_retries?
        @attempts >= MAX_NUMBER_OF_RETRIES
      end

  end
end
