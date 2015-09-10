module GCM
  class UnregisteredDeviceTokenConnection
    include GCM::TokenSerializer

    def initialize(*invalid_tokens)
      @invalid_tokens = invalid_tokens
    end

    def write(json)
      tokens = json[:registration_ids]

      json = {
        'multicast_id' => '123',
        'success' => valid_tokens_count(tokens),
        'failure' => invalid_tokens_count(tokens),
        'canonical_ids' => 0,
        'results' => tokens.map do |token|
          if valid? token
            valid_token_json token
          else
            invalid_token_json token, 'NotRegistered'
          end
        end
      }.to_json

      Mercurius::FakeResponse.new body: json, status: 200
    end

    private
      def valid?(token)
        !invalid? token
      end

      def invalid?(token)
        @invalid_tokens.include?(token)
      end

      def valid_tokens_count(tokens)
        tokens.count { |token| valid? token }
      end

      def invalid_tokens_count(tokens)
        tokens.count { |token| invalid? token }
      end
  end
end
