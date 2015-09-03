module GCM
  class ResultCollection
    include Enumerable

    def initialize(results = [])
      @results = results
    end

    def [](index)
      @results[index]
    end

    def each(&block)
      @results.each &block
    end

    def succeeded
      @results.select &:success?
    end

    def failed
      @results.select &:fail?
    end

    def with_canonical_ids
      @results.select &:has_canonical_id?
    end

    def <<(result)
      @results << result
    end
  end
end
