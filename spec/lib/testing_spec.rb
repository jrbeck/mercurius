describe 'Test mode' do
  context 'GCM' do
    let(:message) { GCM::Notification.new(data: { alert: 'Hey' }) }

    describe 'Normal test connection' do
      let(:service) do
        GCM::Service.new connection: GCM::SuccessfulConnection.new
      end

      it 'Returns all devices sent successfully' do
        responses = service.deliver message, 'token123', 'token456'
        expect(responses.results.succeeded.size).to eq 2
        expect(responses.results.failed.size).to eq 0
      end
    end

    describe 'Invalid device token connection' do
      let(:service) do
        GCM::Service.new connection: GCM::UnregisteredDeviceTokenConnection.new('token456')
      end

      it 'Returns invalid device errors for the tokens provided' do
        responses = service.deliver message, 'token456', 'token123'
        expect(responses.results.failed.size).to eq 1
        expect(responses.results.failed[0].token).to eq 'token456'
        expect(responses.results.failed[0].error).to eq 'NotRegistered'
      end
    end

    describe 'Canonical ID token connection' do
      let(:service) do
        GCM::Service.new connection: GCM::CanonicalIdConnection.new('token456' => 'canonicalToken999')
      end

      it 'returns canonical IDs for the tokens provided' do
        responses = service.deliver message, 'token123', 'token456'
        expect(responses.results.with_canonical_ids.size).to eq 1
        expect(responses.results.with_canonical_ids[0].token).to eq 'token456'
        expect(responses.results.with_canonical_ids[0].canonical_id).to eq 'canonicalToken999'
      end

      it 'matches the canonical count with the amount provided to the connection' do
        responses = service.deliver message, 'token123', 'token456'
        expect(responses[0].to_h['canonical_ids']).to eq 1
      end
    end
  end

  context 'APNS' do
    let(:service) { APNS::Service.new connection: APNS::SuccessfulConnection.new }
    let(:message) { APNS::Notification.new(alert: 'Hey') }

    it 'returns the deliveries sent to APNS' do
      result = service.deliver message, 'token123'
      # Not sure what to test here...
    end
  end
end
