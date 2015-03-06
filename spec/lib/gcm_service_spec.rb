describe GCM::Service do
  let(:service) { GCM::Service.new }
  let(:message) { GCM::Notification.new(alert: 'Hey') }

  it 'should default to the GCM module configs' do
    expect(service.host).to eq GCM.host
    expect(service.key).to GCM.key
  end

  describe '#send' do
    before { stub_request :post, %r[android.googleapis.com/gcm/send] }

    it 'sends a single message' do
      service.deliver message, 'token123'
      expect(WebMock).to have_requested(:post, %r[android.googleapis.com/gcm/send]).
        with(body: { data: { alert: 'Hey' }, registration_ids: ['token123'] })
    end

    it 'sends to multiple tokens via splat' do
      service.deliver message, 'token123', 'token456'
      expect(WebMock).to have_requested(:post, %r[android.googleapis.com/gcm/send]).
        with(body: { data: { alert: 'Hey' }, registration_ids: ['token123', 'token456'] })
    end

    it 'sends to multiple tokens via array' do
      service.deliver message, ['token123', 'token456']
      expect(WebMock).to have_requested(:post, %r[android.googleapis.com/gcm/send]).
        with(body: { data: { alert: 'Hey' }, registration_ids: ['token123', 'token456'] })
    end

    it 'only sends 999 tokens at a time' do
      tokens = (1..1000).to_a.map { |i| "token#{i}" }
      service.deliver message, tokens
      expect(WebMock).to have_requested(:post, %r[android.googleapis.com/gcm/send]).
        with(body: { data: { alert: 'Hey' }, registration_ids: tokens.take(999) })
      expect(WebMock).to have_requested(:post, %r[android.googleapis.com/gcm/send]).
        with(body: { data: { alert: 'Hey' }, registration_ids: [tokens.last] })
    end
  end

  describe 'response' do
    context 'success' do
      before { stub_request :post, %r[android.googleapis.com/gcm/send] }

      it 'processes a 200 response' do
        result = service.deliver message, 'token123'
        expect(result.responses[0].status).to eq 200
        expect(result.responses[0].message).to eq GCM::Response::MESSAGES[200]
        expect(result.failed_device_tokens).to eq []
      end
    end

    context 'failure' do
      before { stub_request(:post, %r[android.googleapis.com/gcm/send]).to_return(status: 400) }

      it 'processes a 400 response' do
        result = service.deliver message, 'token123'
        expect(result.responses[0].status).to eq 400
        expect(result.responses[0].message).to eq GCM::Response::MESSAGES[400]
        expect(result.failed_device_tokens).to eq ['token123']
      end

      it 'adds all failed messages to the failed device tokens array' do
        tokens = (1..1000).to_a.map { |i| "token#{i}" }
        result = service.deliver message, tokens
        expect(result.failed_device_tokens).to include 'token1'
        expect(result.failed_device_tokens).to include 'token1000'
      end
    end

  end
end
