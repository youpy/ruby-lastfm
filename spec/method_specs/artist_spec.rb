require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#artist' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Artist' do
    expect(@lastfm.artist).to be_an_instance_of(Lastfm::MethodCategory::Artist)
  end

  describe '#get_correction' do
    it 'should get corrections' do
      expect(@lastfm).to receive(:request).with('artist.getCorrection', {
        :artist => 'Guns N Roses'
      }).and_return(make_response('artist_get_correction'))

      corrections = @lastfm.artist.get_correction(:artist => 'Guns N Roses')
      expect(corrections[0]['artist']['name']).to eq("Guns N' Roses")
      expect(corrections[0]['artist']['url']).to eq('http://www.last.fm/music/Guns+N%27+Roses')
    end
  end

  describe '#get_top_tracks' do
    it 'should get top tracks' do
      expect(@lastfm).to receive(:request).with('artist.getTopTracks', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_top_tracks'))

      top_tracks = @lastfm.artist.get_top_tracks(:artist => 'Cher')
      expect(top_tracks.size).to be > 1
    end
  end

  describe '#get_top_albums' do
    it 'should get top albums' do
      expect(@lastfm).to receive(:request).with('artist.getTopAlbums', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_top_albums'))

      top_albums = @lastfm.artist.get_top_albums(:artist => 'Cher')
      expect(top_albums.size).to be > 1
    end
  end

  describe '#get_top_fans' do
    it 'should get top fans' do
      expect(@lastfm).to receive(:request).with('artist.getTopFans', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_top_fans'))

      top_fans = @lastfm.artist.get_top_fans(:artist => 'Cher')
      expect(top_fans.size).to eql(50)
      expect(top_fans.first['name']).to eql('D3xperience')
    end
  end

  describe '#get_info' do
    it 'should get info' do
      expect(@lastfm).to receive(:request).with('artist.getInfo', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_info'))

      artist = @lastfm.artist.get_info(:artist => 'Cher')
      expect(artist['name']).to eq('Cher')
      expect(artist['mbid']).to eq('bfcc6d75-a6a5-4bc6-8282-47aec8531818')
      expect(artist['url']).to eq('http://www.last.fm/music/Cher')
      expect(artist['image'].size).to eq(5)
    end
  end

  describe '#get_events' do
    it 'should get events' do
      expect(@lastfm).to receive(:request).with('artist.getEvents', {
        :artist => 'Cher'
      }).and_return(make_response('artist_get_events'))

      events = @lastfm.artist.get_events(:artist => 'Cher')
      expect(events.size).to eq(1)
      expect(events[0]['title']).to eq('Cher')
      expect(events[0]['artists'].size).to eq(2)
      expect(events[0]['artists']['headliner']).to eq('Cher')
      expect(events[0]['venue']['name']).to eq('The Colosseum At Caesars Palace')
      expect(events[0]['venue']['location']['city']).to eq('Las Vegas(, NV)')
      expect(events[0]['venue']['location']['point']['lat']).to eq('36.116143')
      expect(events[0]['image'].size).to eq(4)
      expect(events[0]['image'][0]['size']).to eq('small')
      expect(events[0]['image'][0]['content']).to eq('http://userserve-ak.last.fm/serve/34/34814037.jpg')
      expect(events[0]['startDate']).to eq('Sat, 23 Oct 2010 19:30:00')
      expect(events[0]['tickets']['ticket']['supplier']).to eq('TicketMaster')
      expect(events[0]['tickets']['ticket']['content']).to eq('http://www.last.fm/affiliate/byid/29/1584537/12/ws.artist.events.b25b959554ed76058ac220b7b2e0a026')
      expect(events[0]['tags']['tag']).to eq(['pop', 'dance', 'female vocalists', '80s', 'cher'])
    end
  end

  describe '#get_images' do
    it 'should get images' do
      expect(@lastfm).to receive(:request).with('artist.getImages', {
        :artist => 'Cher',
      }).and_return(make_response('artist_get_images'))

      images = @lastfm.artist.get_images(:artist => 'Cher')
      expect(images.count).to eq(2)
      expect(images[1]['title']).to eq('Early years')
      expect(images[1]['url']).to eq('http://www.last.fm/music/Cher/+images/34877783')
      expect(images[1]['dateadded']).to eq('Tue, 8 Sep 2009 05:40:36')
      expect(images[1]['format']).to eq('jpg')
      expect(images[1]['owner']['type']).to eq('user')
      expect(images[1]['owner']['name']).to eq('djosci_coelho')
      expect(images[1]['owner']['url']).to eq('http://www.last.fm/user/djosci_coelho')
      expect(images[1]['sizes']['size'].length).to eq(6)
    end
  end

  describe '#get_similar' do
    it 'should get similar artists' do
      expect(@lastfm).to receive(:request).with('artist.getSimilar', {
        :artist => 'kid606'
      }).and_return(make_response('artist_get_similar'))

      artists = @lastfm.artist.get_similar(:artist => 'kid606')
      expect(artists.size).to eq(2)
      expect(artists[1]['name']).to eq('Venetian Snares')
      expect(artists[1]['mbid']).to eq('56abaa47-0101-463b-b37e-e961136fec39')
      expect(artists[1]['match']).to eq('100')
      expect(artists[1]['url']).to eq('/music/Venetian+Snares')
      expect(artists[1]['image']).to eq(['http://userserve-ak.last.fm/serve/160/211799.jpg'])
    end
  end

  describe '#get_tags' do
    it 'should get artist tags' do
      expect(@lastfm).to receive(:request).with('artist.getTags', {
        :artist => 'zebrahead',
        :user => 'test',
        :autocorrect => nil
      }).and_return(make_response('artist_get_tags'))

      tags = @lastfm.artist.get_tags(:artist => 'zebrahead', :user => 'test')
      expect(tags.size).to eq(2)
      expect(tags[0]['name']).to eq('punk')
      expect(tags[1]['name']).to eq('Awesome')
    end
  end

  describe '#get_top_tags' do
    context 'with artist' do
      it 'should get artist top tags' do
        expect(@lastfm).to receive(:request).with('artist.getTopTags', {
            :artist => 'Giorgio Moroder',
            :autocorrect => nil
          }).and_return(make_response('artist_get_top_tags'))

        tags = @lastfm.artist.get_top_tags(:artist => 'Giorgio Moroder')
        expect(tags.size).to eq(5)
        expect(tags[0]['name']).to eq('electronic')
        expect(tags[0]['count']).to eq('100')
        expect(tags[0]['url']).to eq('http://www.last.fm/tag/electronic')
        expect(tags[1]['name']).to eq('Disco')
        expect(tags[1]['count']).to eq('97')
        expect(tags[1]['url']).to eq('http://www.last.fm/tag/disco')
      end
    end

    context 'with mbid' do
      it 'should get artist top tags' do
        expect(@lastfm).to receive(:request).with('artist.getTopTags', {
            :mbid => 'xxxxx',
            :autocorrect => nil
          }).and_return(make_response('artist_get_top_tags'))

        tags = @lastfm.artist.get_top_tags(:mbid => 'xxxxx')
        expect(tags.size).to eq(5)
        expect(tags[0]['name']).to eq('electronic')
        expect(tags[0]['count']).to eq('100')
        expect(tags[0]['url']).to eq('http://www.last.fm/tag/electronic')
        expect(tags[1]['name']).to eq('Disco')
        expect(tags[1]['count']).to eq('97')
        expect(tags[1]['url']).to eq('http://www.last.fm/tag/disco')
      end
    end
  end

  describe '#search' do
    it 'should search' do
      expect(@lastfm).to receive(:request).with('artist.search', {
        :artist => 'RADWIMPS',
        :limit => 10,
        :page => 3,
      }).and_return(make_response('artist_search'))

      tracks = @lastfm.artist.search(:artist => 'RADWIMPS', :limit => 10, :page => 3)
      expect(tracks['results']['for']).to eq('RADWIMPS')
      expect(tracks['results']['totalResults']).to eq('3')
      expect(tracks['results']['artistmatches']['artist'].size).to eq(3)
      expect(tracks['results']['artistmatches']['artist'][0]['name']).to eq('RADWIMPS')
    end
  end
end
