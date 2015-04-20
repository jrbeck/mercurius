module GCM
  class Response
    attr_reader :response, :device_tokens

    MESSAGES = {
      200 => 'Success',
      400 => 'The request could not be parsed as JSON or it contained invalid fields',
      401 => 'There was an error authenticating the sender account',
      500 => 'There was an internal error in the GCM server',
      503 => 'GCM server is temporarily unavailable',
      default: 'Unknown error'
    }

    def initialize(response, device_tokens)
      @response = response
      @device_tokens = device_tokens
    end

    def status
      @response.status
    end

    def message
      MESSAGES.fetch(status, MESSAGES[:default])
    end

    def success?
      @response.success?
    end

    def failed?
      !success?
    end

    def has_canonical_ids?
      (response_body.canonical_ids || 0) > 0
    end

    def canonical_ids
      response_body.results.map do |result|
        result["registration_id"]
      end
    end

    def response_body
      @response_body ||= OpenStruct.new JSON.parse(response.body)
    end
  end
end
