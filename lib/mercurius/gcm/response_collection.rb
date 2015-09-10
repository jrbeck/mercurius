module GCM
  class ResponseCollection
    include Enumerable

    attr_reader :recommendations

    def initialize(notification, responses = [])
      @responses = responses
      @notification = notification
    end

    def results
      out = GCM::ResultCollection.new
      @responses.map do |response|
        response.results.each do |result|
          out << result
        end
      end
      out
    end

    def [](index)
      @responses[index]
    end

    def <<(response)
      @responses.concat Array(response).flatten
    end

    def each(&block)
      @responses.each &block
    end
  end
end
