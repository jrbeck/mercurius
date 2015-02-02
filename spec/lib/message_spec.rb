describe APNS::Message do

  describe '#==' do
    it 'doesnt care about object equality' do
      a = APNS::Message.new('token1', alert: '1', badge: 1, other: { a: :b }, sound: 'default')
      b = APNS::Message.new('token1', alert: '1', badge: 1, other: { a: :b }, sound: 'default')
      expect(a == b).to eq true
    end

    %w(alert badge other sound).each do |attr|
      it "must match #{attr} to be considered equal" do
        attributes = { alert: '1', badge: 1, other: { a: :b }, sound: 'default' }
        a = APNS::Message.new('token1', attributes)
        b = APNS::Message.new('token1', attributes.merge(attr => SecureRandom.hex))
        expect(a == b).to eq false
      end
    end

    it 'must match tokens to be considered equal' do
      a = APNS::Message.new('token1')
      b = APNS::Message.new('token2')
      expect(a == b).to eq false
    end
  end

end