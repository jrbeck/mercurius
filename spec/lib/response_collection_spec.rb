describe GCM::ResponseCollection do
  subject do
    GCM::ResponseCollection.new nil, [
      GCM::Response.new(Mercurius::FakeResponse.new(body: '{}', status: 200)),
      GCM::Response.new(Mercurius::FakeResponse.new(body: '{}', status: 201)),
      GCM::Response.new(Mercurius::FakeResponse.new(body: '{}', status: 204))
    ]
  end

  describe 'Enumerable' do
    it '#[] returns the response at the given index' do
      expect(subject[0].status).to eq 200
    end

    it '#each iterates through the responses' do
      subject.each.with_index do |response, i|
        expect(response).to eq subject[i]
      end
    end

    it '#<< adds a new response to the collection' do
      subject << GCM::Response.new(Mercurius::FakeResponse.new(body: '{}', status: 400))
      expect(subject.to_a.last.status).to eq 400
    end
  end
end
