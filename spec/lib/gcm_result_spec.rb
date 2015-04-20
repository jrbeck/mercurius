describe GCM::Result do
  subject { GCM::Result.new nil }

  it 'has_canonical_ids? should return true if any responses have them' do
    allow(subject).to receive(:responses) { [instance_double(GCM::Response, has_canonical_ids?: true), instance_double(GCM::Response, has_canonical_ids?: false)] }
    expect(subject.has_canonical_ids?).to be_truthy
  end

  it 'otherwise, has_canonical_ids should return false' do
    allow(subject).to receive(:responses) { [instance_double(GCM::Response, has_canonical_ids?: false), instance_double(GCM::Response, has_canonical_ids?: false)] }
    expect(subject.has_canonical_ids?).to be_falsy
  end
end
