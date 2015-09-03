describe GCM::Service do
  let(:service) { GCM::Service.new }
  let(:message) { GCM::Notification.new(data: { alert: 'Hey' }) }

  it 'should default to the GCM module configs' do
    expect(service.host).to eq GCM.host
    expect(service.key).to eq GCM.key
  end

  describe '#deliver' do
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
        with(body: { data: { alert: 'Hey' }, registration_ids: ['token1000'] })
    end
  end

  describe '#deliver_topic' do
    before { stub_request :post, %r[android.googleapis.com/gcm/send] }
    let(:message) { { notification: { title: 'hello', body: 'world' } } }

    it 'sends a notification to a topic' do
      service.deliver message, topic: '/topics/global'
      expect(WebMock).to have_requested(:post, %r[android.googleapis.com/gcm/send]).
        with(body: message.merge(to: '/topics/global'))
    end
  end

  describe 'response' do
    context 'success' do
      before { stub_request :post, %r[android.googleapis.com/gcm/send] }

      it 'processes a 200 response' do
        responses = service.deliver message, 'token123'
        expect(responses[0].status).to eq 200
        expect(responses[0].success?).to eq true
        expect(responses.results.failed).to eq []
      end
    end

    describe 'failure' do
      context 401 do
        before { stub_request(:post, %r[android.googleapis.com/gcm/send]).to_return(status: 401) }

        it 'has a meaningful message from #error' do
          responses = service.deliver message, 'token123'
          expect(responses[0].error).to match /Authentication error/
        end
      end

      context 400 do
        before { stub_request(:post, %r[android.googleapis.com/gcm/send]).to_return(status: 400) }

        it 'has a meaningful message from #error' do
          responses = service.deliver message, 'token123'
          expect(responses[0].error).to match /Invalid JSON/
        end
      end

      context 500..599 do
        before do
          stub_request(:post, %r[android.googleapis.com/gcm/send]).
            to_return status: 500, headers: { 'Retry-After' => '120' }
        end

        it 'has a meaningful message from #error' do
          responses = service.deliver message, 'token123'
          expect(responses[0].error).to match /GCM Internal server error/
        end

        it 'returns the Retry-After header from GCM' do
          responses = service.deliver message, 'token123'
          expect(responses[0].retry_after).to eq '120'
        end
      end
    end

  end
end
