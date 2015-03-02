module Mercurius
  module Testing
    class Base

      def self.deliveries
        @@deliveries ||= []
      end

      def self.reset
        @@deliveries = []
      end

      def self.deliveries_to(device_token)
        deliveries.select do |delivery|
          delivery.device_tokens.include? device_token
        end
      end

    end
  end
end
