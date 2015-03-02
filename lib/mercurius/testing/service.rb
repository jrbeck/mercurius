module Mercurius
  module Testing
    module Service

      class Delivery < Struct.new(:notification, :device_tokens)
      end

      def deliver(notification, *device_tokens)
        @deliveries ||= []
        @deliveries << Delivery.new(notification, Array(device_tokens).flatten)
      end

      def deliveries
        @deliveries
      end

      def notifications_to(device_token)
        deliveries_to(device_token).map(&:notification)
      end

      def deliveries_to(device_token)
        deliveries.select do |delivery|
          delivery.device_tokens.include? device_token
        end
      end

    end
  end
end
