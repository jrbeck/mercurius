describe GCM::Notification do
  describe 'with attributes' do
    it 'delegates methods to the attributes hash' do
      notification = GCM::Notification.new({ collapse_key: 'some_key', time_to_live: 123, delay_while_idle: true, dry_run: true })
      expect(notification.collapse_key).to eq 'some_key'
      expect(notification.time_to_live).to eq 123
      expect(notification.delay_while_idle).to eq true
      expect(notification.dry_run).to eq true
    end
  end
end
