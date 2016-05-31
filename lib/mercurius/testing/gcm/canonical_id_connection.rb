module GCM
  class CanonicalIdConnection
    include GCM::TokenSerializer

    def initialize(canonical_ids_map)
      @canonical_ids_map = canonical_ids_map
    end

    def write(json)
      tokens = json[:registration_ids] || Array(json[:to])

      json = {
        'multicast_id' => '123',
        'success' => tokens.size,
        'failure' => 0,
        'canonical_ids' => number_of_tokens_mapped_to_canonical_ids(tokens),
        'results' => canonical_token_json(tokens, @canonical_ids_map)
      }.to_json

      Mercurius::FakeResponse.new body: json, status: 200
    end

    private
      def number_of_tokens_mapped_to_canonical_ids(tokens)
        tokens.count do |token|
          @canonical_ids_map.key? token
        end
      end
  end
end
