module APNS
  class Notification
    include ActiveModel::Model

    MAX_PAYLOAD_BYTES = 2048

    attr_accessor :alert, :badge, :sound, :other
    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes
      super
    end

    def payload
      {
        alert: alert,
        badge: badge,
        sound: sound,
        other: other
      }.compact
    end

    def pack(device_token)
      [0, 0, 32, package_device_token(device_token), 0, packaged_message.bytesize, packaged_message].pack("ccca*cca*")
    end

    def package_device_token(device_token)
      [device_token.gsub(/[\s|<|>]/,'')].pack('H*')
    end

    def packaged_message
      { aps: payload }.to_json.gsub(/\\u([\da-fA-F]{4})/) do |m|
        [$1].pack("H*").unpack("n*").pack("U*")
      end
    end

    def ==(that)
      attributes == that.attributes
    end

    def valid?
      packaged_message.bytesize <= MAX_PAYLOAD_BYTES
    end

  end
end
