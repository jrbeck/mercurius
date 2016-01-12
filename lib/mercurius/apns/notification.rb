module APNS
  class Notification
    include ActiveModel::Model

    MAX_PAYLOAD_BYTES = 2048

    attr_accessor :alert, :badge, :sound, :other, :content_available
    attr_reader :attributes

    validate :payload_size_under_limit

    def initialize(attributes = {})
      @attributes = attributes
      super
    end

    def payload
      {
        'alert' => alert,
        'badge' => badge,
        'sound' => sound,
        'other' => other,
        'content-available' => content_available
      }.compact
    end

    def pack(device_token)
      data = [
        package_device_token(device_token),
        packaged_payload
      ].compact.join
      [2, data.bytes.count, data].pack 'cNa*'
    end

    def ==(other)
      attributes == other.attributes
    end

    private
      def package_device_token(device_token)
        [1, 32, device_token.gsub(/[<\s>]/, '')].pack('cnH64')
      end

      def packaged_payload
        [2, payload_json.bytes.count, payload_json].pack('cna*')
      end

      def payload_json
        payload.to_json
      end

      def payload_size_under_limit
        payload_json.bytesize <= MAX_PAYLOAD_BYTES
      end
  end
end
