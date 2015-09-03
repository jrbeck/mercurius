module GCM
  class ResponseCollection
    attr_reader :recommendations

    def initialize(notification, responses = [])
      @responses = responses
      @notification = notification
    end

    def [](index)
      @responses[index]
    end

    def <<(response)
      @responses << response
    end

    def results
      GCM::ResultCollection.new @responses.map(&:results).flatten
    end
  end
end
