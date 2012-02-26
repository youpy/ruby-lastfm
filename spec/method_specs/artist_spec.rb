require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#artist' do
  before do
    init_lastfm
  end

  it 'should return an instance of Lastfm::Artist' do
    @lastfm.artist.should be_an_instance_of(Lastfm::MethodCategory::Artist)
  end

  it 'should get info' do
    @lastfm.should_receive(:request).with('artist.getInfo', {
      :artist => 'Cher'
    }).and_return(make_response('artist_get_info'))

    artist = @lastfm.artist.get_info('Cher')
    artist['name'].should == 'Cher'
    artist['mbid'].should == 'bfcc6d75-a6a5-4bc6-8282-47aec8531818'
    artist['url'].should == 'http://www.last.fm/music/Cher'
    artist['image'].size.should == 5
  end

  it 'should get events' do
    @lastfm.should_receive(:request).with('artist.getEvents', {
      :artist => 'Cher'
    }).and_return(make_response('artist_get_events'))

    events = @lastfm.artist.get_events('Cher')
    events.size.should == 1
    events[0]['title'].should == 'Cher'
    events[0]['artists'].size.should == 2
    events[0]['artists']['headliner'].should == 'Cher'
    events[0]['venue']['name'].should == 'The Colosseum At Caesars Palace'
    events[0]['venue']['location']['city'].should == 'Las Vegas(, NV)'
    events[0]['venue']['location']['point']['lat'].should == '36.116143'
    events[0]['image'].size.should == 4
    events[0]['image'][0]['size'].should == 'small'
    events[0]['image'][0]['content'].should == 'http://userserve-ak.last.fm/serve/34/34814037.jpg'
    events[0]['startDate'].should == 'Sat, 23 Oct 2010 19:30:00'
    events[0]['tickets']['ticket']['supplier'].should == 'TicketMaster'
    events[0]['tickets']['ticket']['content'].should == 'http://www.last.fm/affiliate/byid/29/1584537/12/ws.artist.events.b25b959554ed76058ac220b7b2e0a026'
    events[0]['tags']['tag'].should == ['pop', 'dance', 'female vocalists', '80s', 'cher']
  end
end
