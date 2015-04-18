module GCM
  class Notification
    include ActiveModel::Model

    def self.special_attrs
      [:collapse_key, :time_to_live, :delay_while_idle, :dry_run]
    end

    attr_accessor :data
    attr_accessor *special_attrs
    # validate delay_while_idle is true/false
    # validate ttl is integer in seconds

    def initialize(attributes = {})
      @attributes = attributes
      super @attributes.slice(*self.class.special_attrs).merge(data: @attributes.except(*self.class.special_attrs))
    end

    def to_h
      hash = {
        data: data,
        collapse_key: collapse_key,
        time_to_live: time_to_live,
        delay_while_idle: delay_while_idle,
        dry_run: dry_run
      }

      hash.reject { |k, v| v.nil? }
    end

    def ==(that)
      attributes == that.attributes
    end

  end
end
