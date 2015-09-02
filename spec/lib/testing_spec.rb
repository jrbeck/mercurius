%w(service base result delivery).each do |rb|
  require File.expand_path("../../../lib/mercurius/testing/#{rb}", __FILE__)
end

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
    let(:message) { GCM::Notification.new(data: { alert: 'Hey' }) }

    it 'returns the deliveries sent to GCM' do
      result = service.deliver message, 'token123'
      delivery = Mercurius::Testing::Base.deliveries[0]
      expect(delivery.device_tokens).to include 'token123'
      expect(delivery.notification.data).to eq Hash[alert: 'Hey']
      expect(result).to be_a_kind_of Mercurius::Testing::Result
    end
  end

  context 'APNS' do
    let(:service) { APNS::MockService.new }
    let(:message) { APNS::Notification.new(alert: 'Hey') }

    it 'returns the deliveries sent to APNS' do
      result = service.deliver message, 'token123'
      delivery = Mercurius::Testing::Base.deliveries[0]
      expect(delivery.device_tokens).to include 'token123'
      expect(delivery.notification.alert).to eq 'Hey'
      expect(result).to be_a_kind_of Mercurius::Testing::Result
    end
  end

end
