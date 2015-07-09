module Mercurius
  module Testing
    module Service

      def deliver(notification, *device_tokens)
        Mercurius::Testing::Base.deliveries << Mercurius::Testing::Delivery.new(notification, Array(device_tokens).flatten)
        Mercurius::Testing::Result.new notification
      end

      def deliver_topic(notification, topic)
        Mercurius::Testing::Base.deliveries << Mercurius::Testing::Delivery.new(notification, [topic])
        Mercurius::Testing::Result.new notification
      end

    end
  end
end
