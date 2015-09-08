module GCM
  class UnregisteredDeviceTokenConnection
    include GCM::TokenSerializer

    def initialize(*invalid_tokens)
      @invalid_tokens = invalid_tokens
    end

    def write(json)
      invalid, valid = json[:registration_ids].partition do |token|
        @invalid_tokens.include? token
      end

      json = {
        'multicast_id' => '123',
        'success' => valid.size,
        'failure' => invalid.size,
        'canonical_ids' => 0,
        'results' => valid_token_json(valid).concat(invalid_token_json(invalid, 'NotRegistered'))
      }.to_json

      Mercurius::FakeResponse.new body: json, status: 200
    end
  end
end
