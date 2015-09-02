module GCM
  class Notification
    include ActiveModel::Model
    attr_accessor :attributes

    def initialize(attributes = {})
      @attributes = attributes
    end

    def to_h
      @attributes
    end

    def ==(that)
      attributes == that.attributes
    end

    def method_missing(method, *args, &block)
      @attributes.fetch(method) { super }
    end
  end
end
