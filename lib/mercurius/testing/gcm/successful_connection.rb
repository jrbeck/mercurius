module GCM
  class SuccessfulConnection
    include GCM::TokenSerializer

    def write(json)
      tokens = json[:registration_ids]

      json = {
        'multicast_id' => '123',
        'success' => tokens.size,
        'failure' => 0,
        'canonical_ids' => 0,
        'results' => tokens.map { |token| valid_token_json(token) }
      }.to_json

      Mercurius::FakeResponse.new body: json, status: 200
    end
  end
end
