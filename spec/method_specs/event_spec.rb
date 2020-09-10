describe '#event' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Event' do
    expect(@lastfm.event).to be_an_instance_of(Lastfm::MethodCategory::Event)
  end

  describe '#get_info' do
    it 'should get info' do
      expect(@lastfm).to receive(:request).with('event.getInfo', {
        :event => 1073657
      }).and_return(make_response('event_get_info'))
      info = @lastfm.event.get_info(:event => 1073657)
      expect(info['title']).to eq('Neko Case')
    end
  end
end
