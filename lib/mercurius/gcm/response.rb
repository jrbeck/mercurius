module GCM
  class Response
    attr_reader :response, :tokens

    def initialize(response, tokens = [])
      @response = response
      @tokens = tokens
    end

    def status
      response.status
    end

    def success?
      response.success?
    end

    def failed?
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

    def to_h
      JSON.parse response.body
    rescue JSON::ParserError
      {}
    end
  end
end
