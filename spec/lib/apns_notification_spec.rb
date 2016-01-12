describe APNS::Notification do
  describe 'validations' do
    it 'is invalid if the payload JSON is too big' do
      expect(subject).to receive(:payload) { 'X' * (APNS::Notification::MAX_PAYLOAD_BYTES + 1) }
      expect(subject).to be_valid
    end

    it 'is valid if the payload JSON is not too big' do
      expect(subject).to receive(:payload) { 'X' * (APNS::Notification::MAX_PAYLOAD_BYTES - 1) }
      expect(subject).to be_valid
    end

    it 'is valid when the payload is just right' do
      expect(subject).to receive(:payload) { 'X' * (APNS::Notification::MAX_PAYLOAD_BYTES) }
      expect(subject).to be_valid
    end
  end

  describe '#==' do
    it 'doesnt care about object equality' do
      a = APNS::Notification.new(alert: '1', badge: 1, other: { a: :b }, sound: 'default', content_available: 0)
      b = APNS::Notification.new(alert: '1', badge: 1, other: { a: :b }, sound: 'default', content_available: 0)
      expect(a == b).to eq true
    end

    %w(alert badge other sound content_available).each do |attr|
      it "must match #{attr} to be considered equal" do
        attributes = { alert: '1', badge: 1, other: { a: :b }, sound: 'default', content_available: 0 }
        a = APNS::Notification.new(attributes)
        b = APNS::Notification.new(attributes.merge(attr => SecureRandom.hex))
        expect(a == b).to eq false
      end
    end
  end
end
