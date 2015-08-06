require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#artist' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Artist' do
    @lastfm.artist.should be_an_instance_of(Lastfm::MethodCategory::Artist)
  end

  describe '#get_correction' do
    it 'should get corrections' do
      @lastfm.should_receive(:request).with('artist.getCorrection', {
        :artist => 'Guns N Roses'
      }).and_return(make_response('artist_get_correction'))

      corrections = @lastfm.artist.get_correction(:artist => 'Guns N Roses')
      corrections[0]['artist']['name'].should == "Guns N' Roses"
      corrections[0]['artist']['url'].should == 'http://www.last.fm/music/Guns+N%27+Roses'
    end
  end

  describe '#get_top_tracks' do
    it 'should get top tracks' do
      @lastfm.should_receive(:request).with('artist.getTopTracks', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_top_tracks'))

      top_tracks = @lastfm.artist.get_top_tracks(:artist => 'Cher')
      top_tracks.size.should > 1
    end
  end

  describe '#get_top_albums' do
    it 'should get top albums' do
      @lastfm.should_receive(:request).with('artist.getTopAlbums', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_top_albums'))

      top_albums = @lastfm.artist.get_top_albums(:artist => 'Cher')
      top_albums.size.should > 1
    end
  end

  describe '#get_top_fans' do
    it 'should get top fans' do
      @lastfm.should_receive(:request).with('artist.getTopFans', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_top_fans'))

      top_fans = @lastfm.artist.get_top_fans(:artist => 'Cher')
      top_fans.should have(50).items
      top_fans.first['name'].should eql('D3xperience')
    end
  end

  describe '#get_info' do
    it 'should get info' do
      @lastfm.should_receive(:request).with('artist.getInfo', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_info'))

      artist = @lastfm.artist.get_info(:artist => 'Cher')
      artist['name'].should == 'Cher'
      artist['mbid'].should == 'bfcc6d75-a6a5-4bc6-8282-47aec8531818'
      artist['url'].should == 'http://www.last.fm/music/Cher'
      artist['image'].size.should == 5
    end
  end

  describe '#get_events' do
    it 'should get events' do
      @lastfm.should_receive(:request).with('artist.getEvents', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_events'))

      events = @lastfm.artist.get_events(:artist => 'Cher')
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

  describe '#get_images' do
    it 'should get images' do
      @lastfm.should_receive(:request).with('artist.getImages', {
        :artist => 'Cher',
      }).and_return(make_response('artist_get_images'))

      images = @lastfm.artist.get_images(:artist => 'Cher')
      images.count.should == 2
      images[1]['title'].should == 'Early years'
      images[1]['url'].should == 'http://www.last.fm/music/Cher/+images/34877783'
      images[1]['dateadded'].should == 'Tue, 8 Sep 2009 05:40:36'
      images[1]['format'].should == 'jpg'
      images[1]['owner']['type'].should == 'user'
      images[1]['owner']['name'].should == 'djosci_coelho'
      images[1]['owner']['url'].should == 'http://www.last.fm/user/djosci_coelho'
      images[1]['sizes']['size'].length.should == 6
    end
  end

  describe '#get_similar' do
    it 'should get similar artists' do
      @lastfm.should_receive(:request).with('artist.getSimilar', {
        :artist => 'kid606'
      }).and_return(make_response('artist_get_similar'))

      artists = @lastfm.artist.get_similar(:artist => 'kid606')
      artists.size.should == 2
      artists[1]['name'].should == 'Venetian Snares'
      artists[1]['mbid'].should == '56abaa47-0101-463b-b37e-e961136fec39'
      artists[1]['match'].should == '100'
      artists[1]['url'].should == '/music/Venetian+Snares'
      artists[1]['image'].should == ['http://userserve-ak.last.fm/serve/160/211799.jpg']
    end
  end

  describe '#get_tags' do
    it 'should get artist tags' do
      @lastfm.should_receive(:request).with('artist.getTags', {
        :artist => 'zebrahead',
        :user => 'test',
        :autocorrect => nil
      }).and_return(make_response('artist_get_tags'))

      tags = @lastfm.artist.get_tags(:artist => 'zebrahead', :user => 'test')
      tags.size.should == 2
      tags[0]['name'].should == 'punk'
      tags[1]['name'].should == 'Awesome'
    end
  end

  describe '#get_top_tags' do
    context 'with artist' do
      it 'should get artist top tags' do
        @lastfm.should_receive(:request).with('artist.getTopTags', {
            :artist => 'Giorgio Moroder',
            :autocorrect => nil
          }).and_return(make_response('artist_get_top_tags'))

        tags = @lastfm.artist.get_top_tags(:artist => 'Giorgio Moroder')
        tags.size.should == 5
        tags[0]['name'].should == 'electronic'
        tags[0]['count'].should == '100'
        tags[0]['url'].should == 'http://www.last.fm/tag/electronic'
        tags[1]['name'].should == 'Disco'
        tags[1]['count'].should == '97'
        tags[1]['url'].should == 'http://www.last.fm/tag/disco'
      end
    end

    context 'with mbid' do
      it 'should get artist top tags' do
        @lastfm.should_receive(:request).with('artist.getTopTags', {
            :mbid => 'xxxxx',
            :autocorrect => nil
          }).and_return(make_response('artist_get_top_tags'))

        tags = @lastfm.artist.get_top_tags(:mbid => 'xxxxx')
        tags.size.should == 5
        tags[0]['name'].should == 'electronic'
        tags[0]['count'].should == '100'
        tags[0]['url'].should == 'http://www.last.fm/tag/electronic'
        tags[1]['name'].should == 'Disco'
        tags[1]['count'].should == '97'
        tags[1]['url'].should == 'http://www.last.fm/tag/disco'
      end
    end
  end

  describe '#search' do
    it 'should search' do
      @lastfm.should_receive(:request).with('artist.search', {
        :artist => 'RADWIMPS',
        :limit => 10,
        :page => 3,
      }).and_return(make_response('artist_search'))

      tracks = @lastfm.artist.search(:artist => 'RADWIMPS', :limit => 10, :page => 3)
      tracks['results']['for'].should == 'RADWIMPS'
      tracks['results']['totalResults'].should == '3'
      tracks['results']['artistmatches']['artist'].size.should == 3
      tracks['results']['artistmatches']['artist'][0]['name'].should == 'RADWIMPS'
    end
  end
end
