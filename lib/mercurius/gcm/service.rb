require 'active_support/core_ext/enumerable'

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
      responses = GCM::ResponseCollection.new notification
      responses << deliver_all(notification, tokens)
      responses << deliver_all(notification, topic) if topic
      responses
    end

    private
      def deliver_all(notification, recipients)
        batch(recipients).map do |batch|
          if batch.many?
            multicast notification, batch
          else
            unicast notification, batch.first
          end
        end
      end

      def unicast(notification, recipient)
        deliver! notification.to_h.merge(to: recipient)
      end

      def multicast(notification, recipients)
        deliver! notification.to_h.merge(registration_ids: recipients)
      end

      def deliver!(payload)
        GCM::Response.new connection.write(payload)
      end

      def batch(recipients, batch_size: BATCH_SIZE)
        Array(recipients).flatten.compact.each_slice batch_size
      end
  end
end
