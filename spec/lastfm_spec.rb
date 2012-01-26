require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lastfm" do
  before do
    @lastfm = Lastfm.new('xxx', 'yyy')
    @response_xml = <<XML
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
<foo>bar</foo></lfm>
XML
    @ok_response = make_response(<<XML)
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
</lfm>
XML
  end

  it 'should have base_uri' do
    Lastfm.base_uri.should eql('http://ws.audioscrobbler.com/2.0')
  end

  describe '.new' do
    it 'should instantiate' do
      @lastfm.should be_an_instance_of(Lastfm)
    end
  end

  describe '#request' do
    it 'should post' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, false, false)
    end

    it 'should post with signature' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, false)
    end

    it 'should post with signature and session (request with authentication)' do
      mock_response = mock(HTTParty::Response)
      @lastfm.session = 'abcdef'
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
          :sk => 'abcdef',
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, true)
    end

    it 'should get' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, false, false)
    end

    it 'should get with signature (request for authentication)' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, false)
    end

    it 'should get with signature and session' do
      mock_response = mock(HTTParty::Response)
      @lastfm.session = 'abcdef'
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
          :sk => 'abcdef',
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, true)
    end

    it 'should raise an error if an api error is ocuured' do
      mock_response = mock(HTTParty::Response)
      mock_response.should_receive(:body).and_return(open(fixture('ng.xml')).read)
      @lastfm.class.should_receive(:post).and_return(mock_response)

      lambda {
        @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post)
      }.should raise_error(Lastfm::ApiError, 'Invalid API key - You must be granted a valid key by last.fm') {|error|
        error.code.should == 10
      }
    end
  end

  describe '#auth' do
    it 'should return an instance of Lastfm::Auth' do
      @lastfm.auth.should be_an_instance_of(Lastfm::MethodCategory::Auth)
    end

    it 'should get token' do
      @lastfm.should_receive(:request).
        with('auth.getToken', {}, :get, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
<token>xxxyyyzzz</token></lfm>
XML

      @lastfm.auth.get_token.should eql('xxxyyyzzz')
    end

    it 'should get session' do
      @lastfm.should_receive(:request).
        with('auth.getSession', { :token => 'xxxyyyzzz' }, :get, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
	<session>
		<name>MyLastFMUsername</name>
		<key>zzzyyyxxx</key>
		<subscriber>0</subscriber>
	</session>
</lfm>
XML
      session = @lastfm.auth.get_session('xxxyyyzzz')
      session['name'].should eql('MyLastFMUsername')
      session['key'].should eql('zzzyyyxxx')
    end

    it 'should get mobile session' do
      @lastfm.should_receive(:request).
        with('auth.getMobileSession', { :username => 'xxxyyyzzz', :authToken => 'xxxxAuthTokenxxxx' }, :get, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
	<session>
		<name>MyLastFMUsername</name>
		<key>zzzyyyxxx</key>
		<subscriber>0</subscriber>
	</session>
</lfm>
XML
      session = @lastfm.auth.get_mobile_session('xxxyyyzzz', 'xxxxAuthTokenxxxx')
      session['name'].should eql('MyLastFMUsername')
      session['key'].should eql('zzzyyyxxx')
    end
  end

  describe '#track' do
    it 'should return an instance of Lastfm::Track' do
      @lastfm.track.should be_an_instance_of(Lastfm::MethodCategory::Track)
    end

    it 'should add tags' do
      @lastfm.should_receive(:request).with('track.addTags', {
          :artist => 'foo artist',
          :track => 'foo track',
          :tags => 'aaa,bbb,ccc'
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.add_tags('foo artist', 'foo track', 'aaa,bbb,ccc').should be_true
    end

    it 'should ban' do
      @lastfm.should_receive(:request).with('track.ban', {
          :artist => 'foo artist',
          :track => 'foo track',
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.ban('foo artist', 'foo track').should be_true
    end

    it 'should get info' do
      @lastfm.should_receive(:request).with('track.getInfo', {
          :artist => 'Cher',
          :track => 'Believe',
          :username => 'youpy',
        }).and_return(make_response('track_get_info'))

      track = @lastfm.track.get_info('Cher', 'Believe', 'youpy')
      track['name'].should eql('Believe')
      track['album']['image'].size.should eql(4)
      track['album']['image'].first['size'].should eql('small')
      track['album']['image'].first['content'].should eql('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      track['toptags']['tag'].size.should eql(5)
      track['toptags']['tag'].first['name'].should eql('pop')
    end

    it 'should get correction' do
      @lastfm.should_receive(:request).with('track.getCorrection', {
          :artist => 'White Stripes',
          :track => 'One More Cup of Coffee',
          :username => 'wainekerr',
        }).and_return(make_response('track_get_correction'))

      correction = @lastfm.track.get_correction('White Stripes', 'One More Cup of Coffee', 'wainekerr')
      correction['track']['name'].should eql('One More Cup of Coffee')
      correction['track']['artist']['name'].should eql('The White Stripes')
      correction['track']['url'].should eql('www.last.fm/music/The+White+Stripes/_/One+More+Cup+of+Coffee')
    end

    it 'should get xml with force array option' do
      @lastfm.should_receive(:request).with('track.getInfo', {
          :artist => 'Cher',
          :track => 'Believe',
          :username => 'youpy',
        }).and_return(make_response('track_get_info_force_array'))

      track = @lastfm.track.get_info('Cher', 'Believe', 'youpy')
      track['album']['image'].size.should eql(1)
      track['album']['image'].first['size'].should eql('small')
      track['album']['image'].first['content'].should eql('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      track['toptags']['tag'].size.should eql(1)
      track['toptags']['tag'].first['name'].should eql('pop')
    end

    it 'should get similar' do
      @lastfm.should_receive(:request).with('track.getSimilar', {
          :artist => 'Cher',
          :track => 'Believe',
        }).and_return(make_response('track_get_similar'))

      tracks = @lastfm.track.get_similar('Cher', 'Believe')
      tracks.size.should eql(250)
      tracks.first['name'].should eql('Strong Enough')
      tracks.first['image'][1]['content'].should eql('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      tracks[1]['image'][0]['content'].should eql('http://userserve-ak.last.fm/serve/34s/8674593.jpg')
    end

    it 'should get tags' do
      @lastfm.should_receive(:request).with('track.getTags', {
          :artist => 'foo artist',
          :track => 'foo track',
        }, :get, true, true).and_return(make_response('track_get_tags'))

      tags = @lastfm.track.get_tags('foo artist', 'foo track')
      tags.size.should eql(2)
      tags[0]['name'].should eql('swedish')
      tags[0]['url'].should eql('http://www.last.fm/tag/swedish')
    end

    it 'should get top fans' do
      @lastfm.should_receive(:request).with('track.getTopFans', {
          :artist => 'foo artist',
          :track => 'foo track',
        }).and_return(make_response('track_get_top_fans'))

      users = @lastfm.track.get_top_fans('foo artist', 'foo track')
      users.size.should eql(2)
      users[0]['name'].should eql('Through0glass')
    end

    it 'should get top tags' do
      @lastfm.should_receive(:request).with('track.getTopTags', {
          :artist => 'foo artist',
          :track => 'foo track',
        }).and_return(make_response('track_get_top_tags'))

      tags = @lastfm.track.get_top_tags('foo artist', 'foo track')
      tags.size.should eql(2)
      tags[0]['name'].should eql('alternative')
      tags[0]['count'].should eql('100')
      tags[0]['url'].should eql('www.last.fm/tag/alternative')
    end

    it 'should love' do
      @lastfm.should_receive(:request).with('track.love', {
          :artist => 'foo artist',
          :track => 'foo track',
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.love('foo artist', 'foo track').should be_true
    end

    it 'should remove tag' do
      @lastfm.should_receive(:request).with('track.removeTag', {
          :artist => 'foo artist',
          :track => 'foo track',
          :tag => 'aaa'
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.remove_tag('foo artist', 'foo track', 'aaa').should be_true
    end

    it 'should search' do
      @lastfm.should_receive(:request).with('track.search', {
          :artist => nil,
          :track => 'Believe',
          :limit => 10,
          :page => 3,
        }).and_return(make_response('track_search'))

      tracks = @lastfm.track.search('Believe', nil, 10, 3)
      tracks['results']['for'].should eql('Believe')
      tracks['results']['totalResults'].should eql('40540')
      tracks['results']['trackmatches']['track'].size.should eql(2)
      tracks['results']['trackmatches']['track'][0]['name'].should eql('Make Me Believe')
    end

    it 'should share' do
      @lastfm.should_receive(:request).with('track.share', {
          :artist => 'foo artist',
          :track => 'foo track',
          :message => 'this is a message',
          :recipient => 'foo@example.com',
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.share('foo artist', 'foo track', 'foo@example.com', 'this is a message').should be_true
    end

    it 'should scrobble' do
      time = Time.now
      @lastfm.should_receive(:request).with('track.scrobble', {
          :artist => 'foo artist',
          :track => 'foo track',
          :album => 'foo album',
          :mbid => '0383dadf-2a4e-4d10-a46a-e9e041da8eb3',
          :timestamp => time,
          :trackNumber => 1,
          :duration => nil,
          :albumArtist => nil,
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.scrobble('foo artist', 'foo track', time, 'foo album', 1, '0383dadf-2a4e-4d10-a46a-e9e041da8eb3', nil, nil)
    end


    it 'should update now playing' do
      @lastfm.should_receive(:request).with('track.updateNowPlaying', {
          :artist => 'foo artist',
          :track => 'foo track',
          :album => 'foo album',
          :mbid => '0383dadf-2a4e-4d10-a46a-e9e041da8eb3',
          :trackNumber => 1,
          :duration => nil,
          :albumArtist => nil,
        }, :post, true, true).and_return(@ok_response)

      @lastfm.track.update_now_playing('foo artist', 'foo track', 'foo album', 1, '0383dadf-2a4e-4d10-a46a-e9e041da8eb3', nil, nil)
    end
  end

  describe '#artist' do
    it 'should return an instance of Lastfm::Artist' do
      @lastfm.artist.should be_an_instance_of(Lastfm::MethodCategory::Artist)
    end

    it 'should get info' do
      @lastfm.should_receive(:request).with('artist.getInfo', {
          :artist => 'Cher'
        }).and_return(make_response('artist_get_info'))

      artist = @lastfm.artist.get_info('Cher')
      artist['name'].should eql('Cher')
      artist['mbid'].should eql('bfcc6d75-a6a5-4bc6-8282-47aec8531818')
      artist['url'].should eql('http://www.last.fm/music/Cher')
      artist['image'].size.should eql(5)
    end

    it 'should get events' do
      @lastfm.should_receive(:request).with('artist.getEvents', {
          :artist => 'Cher'
        }).and_return(make_response('artist_get_events'))

      events = @lastfm.artist.get_events('Cher')
      events.size.should eql(1)
      events[0]['title'].should eql('Cher')
      events[0]['artists'].size.should == 2
      events[0]['artists']['headliner'].should eql('Cher')
      events[0]['venue']['name'].should eql('The Colosseum At Caesars Palace')
      events[0]['venue']['location']['city'].should eql('Las Vegas(, NV)')
      events[0]['venue']['location']['point']['lat'].should eql("36.116143")
      events[0]['image'].size.should eql(4)
      events[0]['image'][0]['size'].should eql('small')
      events[0]['image'][0]['content'].should eql('http://userserve-ak.last.fm/serve/34/34814037.jpg')
      events[0]['startDate'].should eql("Sat, 23 Oct 2010 19:30:00")
      events[0]['tickets']['ticket']['supplier'].should eql("TicketMaster")
      events[0]['tickets']['ticket']['content'].should eql("http://www.last.fm/affiliate/byid/29/1584537/12/ws.artist.events.b25b959554ed76058ac220b7b2e0a026")
      events[0]['tags']['tag'].should == ["pop", "dance", "female vocalists", "80s", "cher"]
    end
  end

  describe '#album' do
    it 'should return an instance of Lastfm::Album' do
      @lastfm.album.should be_an_instance_of(Lastfm::MethodCategory::Album)
    end

    it 'should get info' do
      @lastfm.should_receive(:request).with('album.getInfo', {
          :artist => 'Cher', :album => 'Believe'
        }).and_return(make_response('album_get_info'))

      album = @lastfm.album.get_info('Cher', 'Believe')
      album['name'].should eql('Believe')
      album['artist'].should eql('Cher')
      album['id'].should eql('2026126')
      album['mbid'].should eql('61bf0388-b8a9-48f4-81d1-7eb02706dfb0')
      album['url'].should eql('http://www.last.fm/music/Cher/Believe')
      album['image'].size.should eql(5)
      album['releasedate'].should eql('6 Apr 1999, 00:00')
      album['tracks']['track'].size.should eql(10)
      album['tracks']['track'][0]['name'].should eql('Believe')
      album['tracks']['track'][0]['duration'].should eql('239')
      album['tracks']['track'][0]['url'].should eql('http://www.last.fm/music/Cher/_/Believe')
    end

  end

  describe '#geo' do
    it 'should return an instance of Lastfm::Geo' do
      @lastfm.geo.should be_an_instance_of(Lastfm::MethodCategory::Geo)
    end

    it 'should get events' do
      @lastfm.should_receive(:request).with('geo.getEvents', {
        :location => 'Boulder',
        :distance => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('geo_get_events'))

      events = @lastfm.geo.get_events('Boulder')
      events.size.should eql(1)
      events[0]['title'].should eql('Transistor Festival')
      events[0]['artists'].size.should == 2
      events[0]['artists']['headliner'].should eql('Not Breathing')
      events[0]['venue']['name'].should eql('The Walnut Room')
      events[0]['venue']['location']['city'].should eql('Denver, CO')
      events[0]['venue']['location']['point']['lat'].should eql("39.764316")
      events[0]['image'].size.should eql(4)
      events[0]['image'][0]['size'].should eql('small')
      events[0]['image'][0]['content'].should eql('http://userserve-ak.last.fm/serve/34/166214.jpg')
      events[0]['startDate'].should eql("Fri, 10 Jun 2011 01:58:01")
    end
  end

  describe '#user' do
    it 'should return an instance of Lastfm::User' do
      @lastfm.user.should be_an_instance_of(Lastfm::MethodCategory::User)
    end

    describe '#get_info' do
      it 'should get user info' do
        @lastfm.should_receive(:request).with('user.getInfo', {:user => 'test'}).and_return(make_response('user_get_info'))
        info = @lastfm.user.get_info('test')
        info['id'].should eql('1000002')
      end
    end

    describe '#get_top_artists' do
      it 'should get user\'s top artists' do
        @lastfm.should_receive(:request).with('user.getTopArtists', {
            :user => 'test',
            :period => 'overall',
            :limit => nil,
            :page => nil
          }).and_return(make_response('user_get_top_artists'))

        artists = @lastfm.user.get_top_artists('test', 'overall', nil, nil)

        artists.size.should == 3
        artists[0]['name'].should == "Pain of Salvation"
        artists[0]['playcount'].should == '1354'

        artists[1]['name'].should == "Opeth"
        artists[1]['playcount'].should == '1186'

        artists[2]['name'].should == "Nevermore"
        artists[2]['playcount'].should == '959'
      end
    end

    describe '#get_top_albums' do
      it 'should get user\'s top albums' do
        @lastfm.should_receive(:request).with('user.getTopAlbums', {
            :user => 'test',
            :period => 'overall',
            :limit => nil,
            :page => nil
          }).and_return(make_response('user_get_top_albums'))

        albums = @lastfm.user.get_top_albums('test', 'overall', nil, nil)

        albums.size.should == 2

        albums[0]['rank'].should == '1'
        albums[0]['name'].should == 'The Wall'
        albums[0]['artist']['name'].should == 'Pink Floyd'

        albums[1]['rank'].should == '2'
        albums[1]['name'].should == 'The Perfect Element, Part I'
        albums[1]['artist']['name'].should == 'Pain of Salvation'
      end
    end

    describe '#get_friends' do
      it 'should get user\'s friends' do
        @lastfm.should_receive(:request).with('user.getFriends', {
            :user => 'test',
            :recenttracks => nil,
            :page => nil,
            :limit => nil
          }).and_return(make_response('user_get_friends'))
        friends = @lastfm.user.get_friends('test')
        friends.size.should == 1
        friends[0]['name'].should eql('polaroide')
      end
    end

    describe '#get_neighbours' do
      it 'should get user\'s neighbours' do
        @lastfm.should_receive(:request).with('user.getNeighbours', {
            :user => 'rj',
            :recenttracks => nil,
            :page => nil,
            :limit => nil
          }).and_return(make_response('user_get_neighbours'))
        neighbours = @lastfm.user.get_neighbours('rj')
        neighbours.size.should == 50
        neighbours[0]['name'].should eql('willywongi')
      end
    end

    describe '#get_recent_tracks' do
      it 'should get user\'s recent tracks' do
        @lastfm.should_receive(:request).with('user.getRecentTracks', {
            :user => 'test',
            :page => nil,
            :limit => nil,
            :to => nil,
            :from => nil
          }).and_return(make_response('user_get_recent_tracks'))
        tracks = @lastfm.user.get_recent_tracks('test')
        tracks[1]['artist']['content'].should eql('Kylie Minogue')
        tracks.size.should == 2
      end
    end
  end

  describe '#library' do
    it 'should return an instance of Lastfm::Library' do
      @lastfm.library.should be_an_instance_of(Lastfm::MethodCategory::Library)
    end

    describe '#get_tracks' do
      it 'should get the tracks\' info' do
        @lastfm.should_receive(:request).with('library.getTracks', {
            :user => 'test',
            :artist => 'foo',
            :album => 'bar',
            :limit => nil,
            :page => nil
          }).and_return(make_response('library_get_tracks'))
        tracks = @lastfm.library.get_tracks('test', 'foo', 'bar')
        tracks[0]['name'].should eql('Learning to Live')
        tracks.size.should == 1
      end
    end

    describe '#get_artists' do
      it 'should get the artists\' info' do
        @lastfm.should_receive(:request).with('library.getArtists', {
          :user => 'test',
          :limit => nil,
          :page => nil
        }).and_return(make_response('library_get_artists'))
        artists = @lastfm.library.get_artists('test')
        artists[1]['name'].should eql('Dark Castle')
        artists.size.should == 2
      end
    end
  end
end
