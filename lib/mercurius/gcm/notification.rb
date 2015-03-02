module GCM
  class Notification
    include ActiveModel::Model

    attr_accessor :data, :collapse_key, :time_to_live, :delay_while_idle

    # validate delay_while_idle is true/false
    # validate ttl is integer in seconds

    def initialize(attributes = {})
      @attributes = attributes
      super data: @attributes.except(:collapse_key, :time_to_live, :delay_while_idle)
    end

    def to_h
      hash = {
        data: data,
        collapse_key: collapse_key,
        time_to_live: time_to_live,
        delay_while_idle: delay_while_idle
      }

      hash.reject { |k, v| v.nil? }
    end

    def ==(that)
      attributes == that.attributes
    end

  end
end
