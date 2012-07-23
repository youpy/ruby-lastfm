describe '#event' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Event' do
    @lastfm.event.should be_an_instance_of(Lastfm::MethodCategory::Event)
  end

  describe '#get_info' do
    it 'should get info' do
      @lastfm.should_receive(:request).with('event.getInfo', {
        :event => 1073657
      }).and_return(make_response('event_get_info'))
      info = @lastfm.event.get_info(:event => 1073657)
      info['title'].should == 'Neko Case'
    end
  end
end
