describe APNS::Service do
  let(:service) { APNS::Service.new }

  before do
    # setup APNS
    bundle = File.read File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'apns.pem'))
    APNS.host = 'gateway.sandbox.push.apple.com'
    APNS.port = 2195
    APNS.pem = APNS::Pem.new(data: bundle, password: 'test123')
  end

  it 'should default to the APNS module configs' do
    expect(service.host).to eq 'gateway.sandbox.push.apple.com'
    expect(service.port).to eq 2195
    expect(service.pem.password).to eq 'test123'
  end

  describe '#send' do
    let(:ssl) { FakeSocket.new }
    let(:socket) { FakeSocket.new }

    before do
      expect(OpenSSL::SSL::SSLSocket).to receive(:new) { ssl }
      expect(TCPSocket).to receive(:new) { socket }
    end

    it 'sends a single message' do
      message = APNS::Notification.new(alert: 'Hey')
      service.deliver message, 'token123'
      expect(ssl.wrote[0]).to include ({ alert: 'Hey' }).to_json
    end

    it 'sends to multiple tokens via splat' do
      message = APNS::Notification.new(alert: 'Hey')
      service.deliver message, 'token123', 'token456'
      expect(ssl.wrote.size).to eq 2
    end

    it 'sends to multiple token via array' do
      message = APNS::Notification.new(alert: 'Hey1')
      service.deliver message, ['token123', 'token456']
      expect(ssl.wrote.size).to eq 2
    end

    describe 'persist' do
      it 'with persist, it keeps the SSL connection open until all messages are sent' do
        expect(service.connection).to receive(:close).once
        service.persist do
          service.deliver APNS::Notification.new(alert: 'Hey1'), 'token123'
          service.deliver APNS::Notification.new(alert: 'Hey2'), 'token123'
        end
      end

      it 'without persist, closes the connection on each message' do
        expect(service.connection).to receive(:close).twice
        service.deliver APNS::Notification.new(alert: 'Hey1'), 'token123'
        service.deliver APNS::Notification.new(alert: 'Hey2'), 'token123'
      end
    end
  end

  describe 'retries' do
    it 'tries 3 times before giving up' do
      allow(service.connection).to receive(:open) { raise StandardError }
      expect { service.deliver APNS::Notification.new(alert: 'Hey1'), 'token123' }.to raise_exception(TooManyRetriesError)
      expect(service.attempts).to eq 3
    end
  end

end
