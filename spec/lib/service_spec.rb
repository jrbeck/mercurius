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
      message = APNS::Notification.new(device_token: 'token123', alert: 'Hey')
      service.send message
      expect(ssl.wrote[0]).to include ({ alert: 'Hey' }).to_json
    end

    it 'sends multiple messages via splat' do
      message1 = APNS::Notification.new(device_token: 'token123', alert: 'Hey1')
      message2 = APNS::Notification.new(device_token: 'token123', alert: 'Hey2')
      service.send message1, message2
      expect(ssl.wrote[0]).to include 'Hey1'
      expect(ssl.wrote[1]).to include 'Hey2'
    end

    it 'sends multiple messages via array' do
      message1 = APNS::Notification.new(device_token: 'token123', alert: 'Hey1')
      message2 = APNS::Notification.new(device_token: 'token123', alert: 'Hey2')
      service.send [message1, message2]
      expect(ssl.wrote[0]).to include 'Hey1'
      expect(ssl.wrote[1]).to include 'Hey2'
    end

    describe 'persist' do
      it 'with persist, it keeps the SSL connection open until all messages are sent' do

        expect(service.connection).to receive(:close).once
        service.persist do
          service.send APNS::Notification.new(device_token: 'token123', alert: 'Hey1')
          service.send APNS::Notification.new(device_token: 'token123', alert: 'Hey2')
        end
      end

      it 'without persist, closes the connection on each message' do
        expect(service.connection).to receive(:close).twice
        service.send APNS::Notification.new(device_token: 'token123', alert: 'Hey1')
        service.send APNS::Notification.new(device_token: 'token123', alert: 'Hey2')
      end
    end

    describe 'retries' do
      it 'tries 3 times before giving up' do
        allow(service.connection).to receive(:open) { raise StandardError }
        expect { service.send APNS::Notification.new(device_token: 'token123', alert: 'Hey1') }.to raise_exception(TooManyRetriesError)
        expect(service.attempts).to eq 3
      end
    end

  end
end