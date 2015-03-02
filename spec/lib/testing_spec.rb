require File.expand_path('../../../lib/mercurius/testing/service', __FILE__)
require File.expand_path('../../../lib/mercurius/testing/base', __FILE__)
require File.expand_path('../../../lib/mercurius/testing/delivery', __FILE__)

describe 'Test mode' do

  class GCM::MockService < GCM::Service
    include Mercurius::Testing::Service
  end

  class APNS::MockService < APNS::Service
    include Mercurius::Testing::Service
  end

  after do
    Mercurius::Testing::Base.reset
  end

  context 'GCM' do
    let(:service) { GCM::MockService.new }
    let(:message) { GCM::Notification.new(alert: 'Hey') }

    it 'returns the deliveries sent to GCM' do
      service.deliver message, 'token123'
      delivery = Mercurius::Testing::Base.deliveries[0]
      expect(delivery.device_tokens).to include 'token123'
      expect(delivery.notification.data).to eq Hash[alert: 'Hey']
    end
  end

  context 'APNS' do
    let(:service) { APNS::MockService.new }
    let(:message) { APNS::Notification.new(alert: 'Hey') }

    it 'returns the deliveries sent to APNS' do
      service.deliver message, 'token123'
      delivery = Mercurius::Testing::Base.deliveries[0]
      expect(delivery.device_tokens).to include 'token123'
      expect(delivery.notification.alert).to eq 'Hey'
    end
  end

end
