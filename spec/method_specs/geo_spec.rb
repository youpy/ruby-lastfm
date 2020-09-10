require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#geo' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Geo' do
    expect(@lastfm.geo).to be_an_instance_of(Lastfm::MethodCategory::Geo)
  end

  describe '#get_events' do
    it 'should get events' do
      expect(@lastfm).to receive(:request).with('geo.getEvents', {
        :location => 'Boulder',
        :distance => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('geo_get_events'))

      events = @lastfm.geo.get_events(:location => 'Boulder')
      expect(events.size).to eq(1)
      expect(events[0]['title']).to eq('Transistor Festival')
      expect(events[0]['artists'].size).to eq(2)
      expect(events[0]['artists']['headliner']).to eq('Not Breathing')
      expect(events[0]['venue']['name']).to eq('The Walnut Room')
      expect(events[0]['venue']['location']['city']).to eq('Denver, CO')
      expect(events[0]['venue']['location']['point']['lat']).to eq('39.764316')
      expect(events[0]['image'].size).to eq(4)
      expect(events[0]['image'][0]['size']).to eq('small')
      expect(events[0]['image'][0]['content']).to eq('http://userserve-ak.last.fm/serve/34/166214.jpg')
      expect(events[0]['startDate']).to eq('Fri, 10 Jun 2011 01:58:01')
    end
  end
end
