module GCM
  class Result
    attr_reader :responses

    def initialize(notification)
      @notification = notification
      @responses = []
    end

    def success?
      failed_responses.empty?
    end

    def process_response(response, device_tokens)
      self.responses << GCM::Response.new(response, device_tokens)
    end

    def failed_responses
      @_failed_responses ||= responses.select(&:failed?)
    end

    def failed_device_tokens
      @_failed_device_tokens ||= failed_responses.flat_map { |response| response.device_tokens }
    end

  end
end
