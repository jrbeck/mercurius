describe GCM::Notification do
  describe 'with attributes' do
    it 'should extract special attributes from the hash and assign them' do
      notification = GCM::Notification.new({ collapse_key: 'some_key', time_to_live: 123, delay_while_idle: true, dry_run: true })
      expect(notification.collapse_key).to eq 'some_key'
      expect(notification.time_to_live).to eq 123
      expect(notification.delay_while_idle).to eq true
      expect(notification.dry_run).to eq true
    end

    it 'should move other attributes to data' do
      notification = GCM::Notification.new(data: { message: 'hello' }, dry_run: true)
      expect(notification.dry_run).to eq true
      expect(notification.data).to eq({ message: 'hello' })
    end
  end
end
