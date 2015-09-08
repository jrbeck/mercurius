module GCM
  module TokenSerializer
    def valid_token_json(tokens)
      tokens.map do |token|
        { 'message_id' => SecureRandom.hex }
      end
    end

    def invalid_token_json(tokens, error)
      tokens.map do |token|
        { 'error' => error }
      end
    end

    def canonical_token_json(tokens, canonical_ids_map)
      tokens.map do |token|
        hash = { 'message_id' => SecureRandom.hex }
        if canonical_id = canonical_ids_map[token]
          hash['registration_id'] = canonical_id
        end
        hash
      end
    end
  end
end
