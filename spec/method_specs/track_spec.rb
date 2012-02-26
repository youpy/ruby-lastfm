require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#track' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Track' do
    @lastfm.track.should be_an_instance_of(Lastfm::MethodCategory::Track)
  end

  describe '#add_tags' do
    it 'should add tags' do
      @lastfm.should_receive(:request).with('track.addTags', {
        :artist => 'foo artist',
        :track => 'foo track',
        :tags => 'aaa,bbb,ccc'
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.add_tags('foo artist', 'foo track', 'aaa,bbb,ccc').should be_true
    end
  end

  describe '#ban' do
    it 'should ban' do
      @lastfm.should_receive(:request).with('track.ban', {
        :artist => 'foo artist',
        :track => 'foo track',
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.ban('foo artist', 'foo track').should be_true
    end
  end

  describe '#get_info' do
    it 'should get info' do
      @lastfm.should_receive(:request).with('track.getInfo', {
        :artist => 'Cher',
        :track => 'Believe',
        :username => 'youpy',
      }).and_return(make_response('track_get_info'))

      track = @lastfm.track.get_info('Cher', 'Believe', 'youpy')
      track['name'].should == 'Believe'
      track['album']['image'].size.should == 4
      track['album']['image'].first['size'].should == 'small'
      track['album']['image'].first['content'].should == 'http://userserve-ak.last.fm/serve/64s/8674593.jpg'
      track['toptags']['tag'].size.should == 5
      track['toptags']['tag'].first['name'].should == 'pop'
    end

    it 'should get xml with force array option' do
      @lastfm.should_receive(:request).with('track.getInfo', {
          :artist => 'Cher',
          :track => 'Believe',
          :username => 'youpy',
        }).and_return(make_response('track_get_info_force_array'))

      track = @lastfm.track.get_info('Cher', 'Believe', 'youpy')
      track['album']['image'].size.should == 1
      track['album']['image'].first['size'].should == 'small'
      track['album']['image'].first['content'].should == 'http://userserve-ak.last.fm/serve/64s/8674593.jpg'
      track['toptags']['tag'].size.should == 1
      track['toptags']['tag'].first['name'].should == 'pop'
    end
  end

  describe '#get_correction' do
    it 'should get correction' do
      @lastfm.should_receive(:request).with('track.getCorrection', {
        :artist => 'White Stripes',
        :track => 'One More Cup of Coffee',
        :username => 'wainekerr',
      }).and_return(make_response('track_get_correction'))

      correction = @lastfm.track.get_correction('White Stripes', 'One More Cup of Coffee', 'wainekerr')
      correction['track']['name'].should == 'One More Cup of Coffee'
      correction['track']['artist']['name'].should == 'The White Stripes'
      correction['track']['url'].should == 'www.last.fm/music/The+White+Stripes/_/One+More+Cup+of+Coffee'
    end
  end

  describe '#get_similar' do
    it 'should get similar' do
      @lastfm.should_receive(:request).with('track.getSimilar', {
        :artist => 'Cher',
        :track => 'Believe',
      }).and_return(make_response('track_get_similar'))

      tracks = @lastfm.track.get_similar('Cher', 'Believe')
      tracks.size.should == 5
      tracks.first['name'].should == 'Strong Enough'
      tracks.first['image'][1]['content'].should == 'http://userserve-ak.last.fm/serve/64s/8674593.jpg'
      tracks[1]['image'][0]['content'].should == 'http://userserve-ak.last.fm/serve/34s/8674593.jpg'
    end
  end

  describe '#get_tags' do
    it 'should get tags' do
      @lastfm.should_receive(:request).with('track.getTags', {
        :artist => 'foo artist',
        :track => 'foo track',
      }, :get, true, true).and_return(make_response('track_get_tags'))

      tags = @lastfm.track.get_tags('foo artist', 'foo track')
      tags.size.should == 2
      tags[0]['name'].should == 'swedish'
      tags[0]['url'].should == 'http://www.last.fm/tag/swedish'
    end
  end

  describe '#get_top_fans' do
    it 'should get top fans' do
      @lastfm.should_receive(:request).with('track.getTopFans', {
        :artist => 'foo artist',
        :track => 'foo track',
      }).and_return(make_response('track_get_top_fans'))

      users = @lastfm.track.get_top_fans('foo artist', 'foo track')
      users.size.should == 2
      users[0]['name'].should == 'Through0glass'
    end
  end

  describe '#get_top_tags' do
    it 'should get top tags' do
      @lastfm.should_receive(:request).with('track.getTopTags', {
        :artist => 'foo artist',
        :track => 'foo track',
      }).and_return(make_response('track_get_top_tags'))

      tags = @lastfm.track.get_top_tags('foo artist', 'foo track')
      tags.size.should == 2
      tags[0]['name'].should == 'alternative'
      tags[0]['count'].should == '100'
      tags[0]['url'].should == 'www.last.fm/tag/alternative'
    end
  end

  describe '#love' do
    it 'should love' do
      @lastfm.should_receive(:request).with('track.love', {
        :artist => 'foo artist',
        :track => 'foo track',
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.love('foo artist', 'foo track').should be_true
    end
  end

  describe '#remove_tag' do
    it 'should remove tag' do
      @lastfm.should_receive(:request).with('track.removeTag', {
        :artist => 'foo artist',
        :track => 'foo track',
        :tag => 'aaa'
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.remove_tag('foo artist', 'foo track', 'aaa').should be_true
    end
  end

  describe '#search' do
    it 'should search' do
      @lastfm.should_receive(:request).with('track.search', {
        :artist => nil,
        :track => 'Believe',
        :limit => 10,
        :page => 3,
      }).and_return(make_response('track_search'))

      tracks = @lastfm.track.search('Believe', nil, 10, 3)
      tracks['results']['for'].should == 'Believe'
      tracks['results']['totalResults'].should == '40540'
      tracks['results']['trackmatches']['track'].size.should == 2
      tracks['results']['trackmatches']['track'][0]['name'].should == 'Make Me Believe'
    end
  end

  describe '#share' do
    it 'should share' do
      @lastfm.should_receive(:request).with('track.share', {
        :artist => 'foo artist',
        :track => 'foo track',
        :message => 'this is a message',
        :recipient => 'foo@example.com',
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.share('foo artist', 'foo track', 'foo@example.com', 'this is a message').should be_true
    end
  end

  describe '#scrobble' do
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
  end

  describe '#update_now_playing' do
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
end
