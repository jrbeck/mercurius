module GCM
  class Service
    include ActiveModel::Model

    BATCH_SIZE = 999

    attr_accessor :host, :key, :connection
    attr_reader :attempts

    def initialize(*)
      super
      @host ||= GCM.host
      @key ||= GCM.key
      @connection ||= GCM::Connection.new(@host, @key)
      @attempts = 0
    end

    def deliver(notification, *tokens, topic: nil)
      responses = GCM::ResponseCollection.new(notification)
      responses << deliver_to_tokens(notification, tokens)
      responses << deliver_to_topic(notification, topic) if topic
      responses
    end

    private
      def each_batch_of_tokens(tokens, batch_size: BATCH_SIZE, &block)
        Array(tokens).flatten.compact.each_slice(batch_size)
      end

      def deliver_to_tokens(notification, tokens)
        each_batch_of_tokens(tokens).map do |tokens|
          payload = notification.to_h.merge registration_ids: tokens
          GCM::Response.new(connection.write(payload), tokens)
        end
      end

      def deliver_to_topic(notification, topic)
        GCM::Response.new connection.write(notification.to_h.merge(to: topic))
      end
  end
end
