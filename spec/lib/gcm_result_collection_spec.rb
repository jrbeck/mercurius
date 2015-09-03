describe GCM::ResultCollection do
  subject do
    GCM::ResultCollection.new [
      GCM::Result.new({ message_id: '1' }, 'token123'),
      GCM::Result.new({ message_id: '2', registration_id: 'canonicalToken456' }, 'token456'),
      GCM::Result.new({ error: 'DeviceMessageRateExceeded' }, nil)
    ]
  end

  describe '#succeeded' do
    it 'returns only the successful results' do
      expect(subject.succeeded.count).to eq 2
      expect(subject.succeeded[0].message_id).to eq '1'
      expect(subject.succeeded[1].message_id).to eq '2'
    end
  end

  describe '#failed' do
    it 'returns only the failed results' do
      expect(subject.failed.count).to eq 1
      expect(subject.failed[0].error).to eq 'DeviceMessageRateExceeded'
    end
  end

  describe '#with_canonical_ids' do
    it 'returns only the results with canonical ids' do
      expect(subject.with_canonical_ids.count).to eq 1
      expect(subject.with_canonical_ids[0].token).to eq 'token456'
      expect(subject.with_canonical_ids[0].canonical_id).to eq 'canonicalToken456'
    end
  end
end
