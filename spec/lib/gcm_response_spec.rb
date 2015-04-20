describe GCM::Response do
  subject { GCM::Response.new nil, nil }

  it 'has_canonical_ids? should return true if the response body has canonical ids' do
    allow(subject).to receive(:response_body) { OpenStruct.new canonical_ids: 1 }
    expect(subject.has_canonical_ids?).to be_truthy
  end

  it 'has_canonical_ids? should return false if the body has no canonical ids' do
    allow(subject).to receive(:response_body) { OpenStruct.new success: 1 }
    expect(subject.has_canonical_ids?).to be_falsy
  end

  it 'canonical_ids should return an array of registration ids' do
    allow(subject).to receive(:response_body) { OpenStruct.new results: [{'registration_id' => '1234'}, {'registration_id' => '5678'}, {}] }
    expect(subject.canonical_ids).to eq ['1234', '5678', nil]
  end

  it 'response_body should return an openstruct of the response.body' do
    allow(subject).to receive(:response) { OpenStruct.new body: { one: 'two' }.to_json }
    result = subject.response_body
    expect(result).to be_a OpenStruct
    expect(result.to_h).to eq({one: 'two'})
  end
end