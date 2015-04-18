module Mercurius
  module Testing
    class Result
      attr_reader :responses

      def initialize(notification)
        @notification = notification
        @responses = []
      end

      def success?
        true
      end

      def process_response(*)
      end

      def failed_responses
        []
      end

      def failed_device_tokens
        []
      end

      def has_canonical_ids?
        false
      end

    end
  end
end
