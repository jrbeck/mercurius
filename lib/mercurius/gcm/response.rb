module GCM
  class Response
    attr_reader :http_response, :tokens

    def initialize(http_response, tokens = [])
      @http_response = http_response
      @tokens = tokens
    end

    def status
      http_response.status
    end

    def success?
      http_response.success?
    end

    def fail?
      !success?
    end

    def results
      @_results ||= begin
        results = to_h.fetch 'results', []
        results.map!.with_index do |attributes, i|
          GCM::Result.new attributes, tokens[i]
        end
        ResultCollection.new(results)
      end
    end

    def error
      case status
      when 401
        'Authentication error with GCM. Check the server whitelist and the validity of your project key.'
      when 400
        'Invalid JSON was sent to GCM.'
      when 500..599
        'GCM Internal server error.'
      else
        nil
      end
    end

    def retry_after
      http_response.headers['Retry-After']
    end

    def to_h
      JSON.parse http_response.body
    rescue JSON::ParserError
      {}
    end
  end
end
