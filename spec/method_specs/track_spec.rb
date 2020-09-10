require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#track' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Track' do
    expect(@lastfm.track).to be_an_instance_of(Lastfm::MethodCategory::Track)
  end

  describe '#add_tags' do
    it 'should add tags' do
      expect(@lastfm).to receive(:request).with('track.addTags', {
        :artist => 'foo artist',
        :track => 'foo track',
        :tags => 'aaa,bbb,ccc'
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.track.add_tags(
        :artist => 'foo artist',
        :track => 'foo track',
        :tags => 'aaa,bbb,ccc'
        )).to be_truthy
    end
  end

  describe '#ban' do
    it 'should ban' do
      expect(@lastfm).to receive(:request).with('track.ban', {
        :artist => 'foo artist',
        :track => 'foo track',
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.track.ban(:artist => 'foo artist', :track => 'foo track')).to be_truthy
    end
  end

  describe '#get_info' do
    it 'should get info by track and artist' do
      expect(@lastfm).to receive(:request).with('track.getInfo', {
        :artist => 'Cher',
        :track => 'Believe',
        :username => 'youpy',
      }).and_return(make_response('track_get_info'))

      track = @lastfm.track.get_info(
        :artist => 'Cher',
        :track => 'Believe',
        :username => 'youpy')
      expect(track['name']).to eq('Believe')
      expect(track['album']['image'].size).to eq(4)
      expect(track['album']['image'].first['size']).to eq('small')
      expect(track['album']['image'].first['content']).to eq('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      expect(track['toptags']['tag'].size).to eq(5)
      expect(track['toptags']['tag'].first['name']).to eq('pop')
    end

    it 'should get info by mbid' do
      expect(@lastfm).to receive(:request).with('track.getInfo', {
          :mbid => 'xxx',
          :username => nil
        }
      ).and_return(make_response('track_get_info'))

      track = @lastfm.track.get_info(
        :mbid => 'xxx'
      )
      expect(track['name']).to eq('Believe')
      expect(track['album']['image'].size).to eq(4)
      expect(track['album']['image'].first['size']).to eq('small')
      expect(track['album']['image'].first['content']).to eq('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      expect(track['toptags']['tag'].size).to eq(5)
      expect(track['toptags']['tag'].first['name']).to eq('pop')
    end

    it 'should get xml with force array option' do
      expect(@lastfm).to receive(:request).with('track.getInfo', {
        :artist => 'Cher',
        :track => 'Believe',
        :username => 'youpy',
      }).and_return(make_response('track_get_info_force_array'))

      track = @lastfm.track.get_info(
        :artist => 'Cher',
        :track => 'Believe',
        :username => 'youpy')
      expect(track['album']['image'].size).to eq(1)
      expect(track['album']['image'].first['size']).to eq('small')
      expect(track['album']['image'].first['content']).to eq('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      expect(track['toptags']['tag'].size).to eq(1)
      expect(track['toptags']['tag'].first['name']).to eq('pop')
    end
  end

  describe '#get_correction' do
    it 'should get correction' do
      expect(@lastfm).to receive(:request).with('track.getCorrection', {
        :artist => 'White Stripes',
        :track => 'One More Cup of Coffee'
      }).and_return(make_response('track_get_correction'))

      corrections = @lastfm.track.get_correction(
        :artist => 'White Stripes',
        :track => 'One More Cup of Coffee')
      correction = corrections.first

      expect(corrections.size).to eql(1)
      expect(correction['track']['name']).to eq('One More Cup of Coffee')
      expect(correction['track']['artist']['name']).to eq('The White Stripes')
      expect(correction['track']['url']).to eq('www.last.fm/music/The+White+Stripes/_/One+More+Cup+of+Coffee')
    end
  end

  describe '#get_similar' do
    it 'should get similar' do
      expect(@lastfm).to receive(:request).with('track.getSimilar', {
        :artist => 'Cher',
        :track => 'Believe',
        :limit => nil
      }).and_return(make_response('track_get_similar'))

      tracks = @lastfm.track.get_similar(
        :artist => 'Cher',
        :track => 'Believe')
      expect(tracks.size).to eq(5)
      expect(tracks.first['name']).to eq('Strong Enough')
      expect(tracks.first['image'][1]['content']).to eq('http://userserve-ak.last.fm/serve/64s/8674593.jpg')
      expect(tracks[1]['image'][0]['content']).to eq('http://userserve-ak.last.fm/serve/34s/8674593.jpg')
    end
  end

  describe '#get_tags' do
    it 'should get tags' do
      expect(@lastfm).to receive(:request).with('track.getTags', {
        :artist => 'foo artist',
        :track => 'foo track',
      }).and_return(make_response('track_get_tags'))

      tags = @lastfm.track.get_tags(
        :artist => 'foo artist',
        :track => 'foo track')
      expect(tags.size).to eq(2)
      expect(tags[0]['name']).to eq('swedish')
      expect(tags[0]['url']).to eq('http://www.last.fm/tag/swedish')
    end
  end

  describe '#get_top_fans' do
    it 'should get top fans' do
      expect(@lastfm).to receive(:request).with('track.getTopFans', {
        :artist => 'foo artist',
        :track => 'foo track',
      }).and_return(make_response('track_get_top_fans'))

      users = @lastfm.track.get_top_fans(
        :artist => 'foo artist',
        :track => 'foo track')
      expect(users.size).to eq(2)
      expect(users[0]['name']).to eq('Through0glass')
    end
  end

  describe '#get_top_tags' do
    it 'should get top tags' do
      expect(@lastfm).to receive(:request).with('track.getTopTags', {
        :artist => 'foo artist',
        :track => 'foo track',
      }).and_return(make_response('track_get_top_tags'))

      tags = @lastfm.track.get_top_tags(
        :artist => 'foo artist',
        :track => 'foo track')
      expect(tags.size).to eq(2)
      expect(tags[0]['name']).to eq('alternative')
      expect(tags[0]['count']).to eq('100')
      expect(tags[0]['url']).to eq('www.last.fm/tag/alternative')
    end
  end

  describe '#love' do
    it 'should love' do
      expect(@lastfm).to receive(:request).with('track.love', {
        :artist => 'foo artist',
        :track => 'foo track',
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.track.love(
        :artist => 'foo artist',
        :track => 'foo track')).to be_truthy
    end
  end

  describe '#remove_tag' do
    it 'should remove tag' do
      expect(@lastfm).to receive(:request).with('track.removeTag', {
        :artist => 'foo artist',
        :track => 'foo track',
        :tag => 'aaa'
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.track.remove_tag(
        :artist => 'foo artist',
        :track => 'foo track',
        :tag => 'aaa')).to be_truthy
    end
  end

  describe '#search' do
    it 'should search' do
      expect(@lastfm).to receive(:request).with('track.search', {
        :artist => nil,
        :track => 'Believe',
        :limit => 10,
        :page => 3,
      }).and_return(make_response('track_search'))

      tracks = @lastfm.track.search(
        :track => 'Believe',
        :limit => 10,
        :page => 3)
      expect(tracks['results']['for']).to eq('Believe')
      expect(tracks['results']['totalResults']).to eq('40540')
      expect(tracks['results']['trackmatches']['track'].size).to eq(2)
      expect(tracks['results']['trackmatches']['track'][0]['name']).to eq('Make Me Believe')
    end

    it 'should always return an arrays of tracks' do
      expect(@lastfm).to receive(:request).with('track.search', {
        :artist => nil,
        :track => 'Believe',
        :limit => 10,
        :page => 3,
      }).and_return(make_response('track_search_single_track'))

      tracks = @lastfm.track.search(
        :track => 'Believe',
        :limit => 10,
        :page => 3)
      expect(tracks['results']['for']).to eq('Believe')
      expect(tracks['results']['totalResults']).to eq('40540')
      expect(tracks['results']['trackmatches']['track'].size).to eq(1)
      expect(tracks['results']['trackmatches']['track'][0]['name']).to eq('Make Me Believe')
    end

    it 'should return an empty array if no match found' do
      expect(@lastfm).to receive(:request).with('track.search', {
        :artist => nil,
        :track => 'Believe',
        :limit => 10,
        :page => 1,
      }).and_return(make_response('track_search_no_match'))

      tracks = @lastfm.track.search(
        :track => 'Believe',
        :limit => 10,
        :page => 1)
      expect(tracks['results']['for']).to eq('Believe')
      expect(tracks['results']['totalResults']).to eq('0')
      expect(tracks['results']['trackmatches']['track'].size).to eq(0)
    end
  end

  describe '#share' do
    it 'should share' do
      expect(@lastfm).to receive(:request).with('track.share', {
        :artist => 'foo artist',
        :track => 'foo track',
        :message => 'this is a message',
        :recipient => 'foo@example.com',
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.track.share(
        :artist => 'foo artist',
        :track => 'foo track',
        :recipient => 'foo@example.com',
        :message => 'this is a message')).to be_truthy
    end
  end

  describe '#scrobble' do
    it 'should scrobble' do
      time = Time.now
      expect(@lastfm).to receive(:request).with('track.scrobble', {
        :artist => 'foo artist',
        :track => 'foo track',
        :album => 'foo album',
        :mbid => '0383dadf-2a4e-4d10-a46a-e9e041da8eb3',
        :timestamp => time,
        :trackNumber => 1,
        :duration => nil,
        :albumArtist => nil,
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.scrobble(
        :artist => 'foo artist',
        :track => 'foo track',
        :timestamp => time,
        :album => 'foo album',
        :trackNumber => 1,
        :mbid => '0383dadf-2a4e-4d10-a46a-e9e041da8eb3')
    end
  end

  describe '#update_now_playing' do
    it 'should update now playing' do
      expect(@lastfm).to receive(:request).with('track.updateNowPlaying', {
        :artist => 'foo artist',
        :track => 'foo track',
        :album => 'foo album',
        :mbid => '0383dadf-2a4e-4d10-a46a-e9e041da8eb3',
        :trackNumber => 1,
        :duration => nil,
        :albumArtist => nil,
      }, :post, true, true).and_return(@ok_response)

      @lastfm.track.update_now_playing(
        :artist =>'foo artist',
        :track => 'foo track',
        :album => 'foo album',
        :trackNumber => 1,
        :mbid => '0383dadf-2a4e-4d10-a46a-e9e041da8eb3')
    end
  end

  describe '#unlove' do
    it 'should unlove' do
      expect(@lastfm).to receive(:request).with('track.unlove', {
        :artist => 'foo artist',
        :track => 'foo track',
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.track.unlove(
        :artist => 'foo artist',
        :track => 'foo track')).to be_truthy
    end
  end
end
