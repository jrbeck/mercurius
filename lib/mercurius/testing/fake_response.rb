module Mercurius
  class FakeResponse
    attr_accessor :body, :status

    def initialize(options = {})
      @body = options[:body]
      @status = options[:status]
    end

    def success?
      (200..399).include? @status
    end
  end
end
