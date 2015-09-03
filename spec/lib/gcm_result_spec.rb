describe GCM::Result do
  describe '#canonical_id' do
    it 'returns the registration_id from the GCM response JSON' do
      result = GCM::Result.new({ message_id: '1:08', registration_id: 'canonicalToken123' }, nil)
      expect(result.canonical_id).to eq 'canonicalToken123'
    end

    it 'returns nil if no canonical ID is given by GCM' do
      result = GCM::Result.new({ message_id: '1:08' }, nil)
      expect(result.canonical_id).to be_nil
    end
  end

  describe '#has_canonical_id?' do
    it 'returns true when canonical_id is given by GCM' do
      result = GCM::Result.new({ message_id: '1:08', registration_id: 'canonicalToken123' }, nil)
      expect(result.has_canonical_id?).to be_truthy
    end

    it 'returns false when canonical_id is not given by GCM' do
      result = GCM::Result.new({ message_id: '1:08' }, nil)
      expect(result.has_canonical_id?).to be_falsey
    end
  end

  describe '#success?' do
    it 'returns true when the message is sent and returned with a message id' do
      result = GCM::Result.new({ message_id: '1:08' }, nil)
      expect(result).to be_success
    end

    it 'returns false otherwise' do
      result = GCM::Result.new({ error: 'DeviceMessageRateExceeded' }, nil)
      expect(result).to_not be_success
    end
  end

  describe '#error' do
    it 'returns the error from GCM' do
      result = GCM::Result.new({ error: 'DeviceMessageRateExceeded' }, nil)
      expect(result.error).to eq 'DeviceMessageRateExceeded'
    end

    it 'returns nil when there is no error' do
      result = GCM::Result.new({ message_id: '1:08' }, nil)
      expect(result.error).to be_nil
    end
  end
end
