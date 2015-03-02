describe APNS::Notification do

  describe '#==' do
    it 'doesnt care about object equality' do
      a = APNS::Notification.new(alert: '1', badge: 1, other: { a: :b }, sound: 'default')
      b = APNS::Notification.new(alert: '1', badge: 1, other: { a: :b }, sound: 'default')
      expect(a == b).to eq true
    end

    %w(alert badge other sound).each do |attr|
      it "must match #{attr} to be considered equal" do
        attributes = { alert: '1', badge: 1, other: { a: :b }, sound: 'default' }
        a = APNS::Notification.new(attributes)
        b = APNS::Notification.new(attributes.merge(attr => SecureRandom.hex))
        expect(a == b).to eq false
      end
    end
  end

end
