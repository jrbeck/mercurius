describe APNS do

  it 'sets up the development mode' do
    APNS.mode = :development
    expect(APNS.host).to eq APNS::HOSTS[:development]
  end

  it 'sets up the production mode' do
    APNS.mode = :production
    expect(APNS.host).to eq APNS::HOSTS[:production]
  end

  it 'will not change the host if an invalid mode is specified' do
    APNS.host = 'host'
    expect { APNS.mode = :overdrive }.to raise_error InvalidApnsModeError
    expect(APNS.host).to eq 'host'
  end

end
