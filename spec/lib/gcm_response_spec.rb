describe GCM::Response do
  class FakeResponse < Struct.new(:hash, :success)
    def body; hash.to_json; end
    def success?; success; end
  end

  let(:json) { Hash.new }
  let(:success) { true }
  let(:tokens) { ['token123', 'token456'] }

  let(:response) do
    GCM::Response.new FakeResponse.new(json, success), tokens
  end

  describe '#results' do
    let(:json) do
      {
        multicast_id: 108, success: 2, failure: 1, canonical_ids: 1, results: [
          { message_id: '1' },
          { message_id: '2', registration_id: 'canonicalToken456' },
          { error: 'DeviceMessageRateExceeded' }
        ]
      }
    end

    it 'returns an array of the results in a response' do
      expect(response.results.count).to eq 3
      expect(response.results[0].message_id).to eq '1'
      expect(response.results[0].token).to eq 'token123'
      expect(response.results[1].message_id).to eq '2'
      expect(response.results[1].token).to eq 'token456'
      expect(response.results[1].canonical_id).to eq 'canonicalToken456'
    end

    describe 'ResultCollection#succeeded' do
      subject { response.results.succeeded }

      it 'returns only the successful results' do
        expect(subject.count).to eq 2
        expect(subject[0].message_id).to eq '1'
        expect(subject[1].message_id).to eq '2'
      end
    end

    describe 'ResultCollection#failed' do
      subject { response.results.failed }

      it 'returns only the failed results' do
        expect(subject.count).to eq 1
        expect(subject[0].error).to eq 'DeviceMessageRateExceeded'
      end
    end

    describe 'ResultCollection#with_canonical_ids' do
      subject { response.results.with_canonical_ids }

      it 'returns only the results with canonical ids' do
        expect(subject.count).to eq 1
        expect(subject[0].token).to eq 'token456'
        expect(subject[0].canonical_id).to eq 'canonicalToken456'
      end
    end
  end

  describe '#success?' do
    context 'Faraday response is successful' do
      let(:success) { true }

      it 'returns true' do
        expect(response).to be_success
      end
    end

    context 'Faraday response is not successful' do
      let(:success) { false }

      it 'returns false' do
        expect(response).to_not be_success
      end
    end
  end
end
