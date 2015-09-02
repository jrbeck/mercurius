module GCM
  class Service
    include ActiveModel::Model

    MAX_NUMBER_OF_RETRIES = 3
    BATCH_SIZE = 999

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
      # result = GCM::Result.new(notification)
      response = GCM::Response.new(notification)

      each_batch_of_tokens(device_tokens) do |tokens|
        payload = notification.to_h.merge registration_ids: tokens
        response << GCM::Result.new(connection.write(payload), tokens)
      end

      response
    end

    def deliver_topic(notification, topic)
      GCM::Result.new(notification).tap do |result|
        result.process_response connection.write(notification.to_h.merge(to: topic)), [topic]
      end
    end

    private
      def each_batch_of_tokens(tokens, batch_size: BATCH_SIZE, &block)
        Array(tokens).flatten.each_slice(batch_size) do |batch|
          yield batch
        end
      end

      def too_many_retries?
        @attempts >= MAX_NUMBER_OF_RETRIES
      end
  end
end
