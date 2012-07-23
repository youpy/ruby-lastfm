require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#geo' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Geo' do
    @lastfm.geo.should be_an_instance_of(Lastfm::MethodCategory::Geo)
  end

  describe '#get_events' do
    it 'should get events' do
      @lastfm.should_receive(:request).with('geo.getEvents', {
        :location => 'Boulder',
        :distance => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('geo_get_events'))

      events = @lastfm.geo.get_events(:location => 'Boulder')
      events.size.should == 1
      events[0]['title'].should == 'Transistor Festival'
      events[0]['artists'].size.should == 2
      events[0]['artists']['headliner'].should == 'Not Breathing'
      events[0]['venue']['name'].should == 'The Walnut Room'
      events[0]['venue']['location']['city'].should == 'Denver, CO'
      events[0]['venue']['location']['point']['lat'].should == '39.764316'
      events[0]['image'].size.should == 4
      events[0]['image'][0]['size'].should == 'small'
      events[0]['image'][0]['content'].should == 'http://userserve-ak.last.fm/serve/34/166214.jpg'
      events[0]['startDate'].should == 'Fri, 10 Jun 2011 01:58:01'
    end
  end
end
