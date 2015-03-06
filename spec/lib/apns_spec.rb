describe APNS do

  it 'sets up the develop mode' do
    APNS.set_mode(:develop)
    expect(APNS.host).to eq APNS::HOSTS[:develop]
  end

  it 'sets up the production mode' do
    APNS.set_mode(:production)
    expect(APNS.host).to eq APNS::HOSTS[:production]
  end

  it 'will not change the host if an invalid mode is specified' do
    APNS.host = 'host'
    expect { APNS.set_mode(:overdrive) }.to raise_error
    expect(APNS.host).to eq 'host'
  end

end
