require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#tag' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Tag' do
    expect(@lastfm.tag).to be_an_instance_of(Lastfm::MethodCategory::Tag)
  end

  describe '#get_top_artists' do
    it 'should get top artists of some tag' do
      expect(@lastfm).to receive(:request).with('tag.getTopArtists', {
        :tag => 'Disco',
        :limit => nil,
        :page => nil
      }).and_return(make_response('tag_get_top_artists'))

      artists = @lastfm.tag.get_top_artists(:tag => 'Disco')
      expect(artists.size).to eq(5)
      expect(artists[0]['name']).to eq('Bee Gees')
      expect(artists[0]['url']).to eq('http://www.last.fm/music/Bee+Gees')
      expect(artists[1]['name']).to eq('ABBA')
    end
  end

  describe '#get_top_tracks' do
    it 'should get top tracks of a given tag' do
      expect(@lastfm).to receive(:request).with('tag.getTopTracks', {
        :tag => 'Disco',
        :limit => 5,
        :page => nil
      }).and_return(make_response('tag_get_top_tracks'))

      tracks = @lastfm.tag.get_top_tracks(:tag => 'Disco', :limit => 5)
      expect(tracks.size).to eq(5)
      expect(tracks[0]['name']).to eq('Stayin\' Alive')
      expect(tracks[0]['url']).to eq('http://www.last.fm/music/Bee+Gees/_/Stayin%27+Alive')
      expect(tracks[0]['artist']['name']).to eq('Bee Gees')
      expect(tracks[1]['name']).to eq('September')
    end
  end

  describe '#get_top_albums' do
    it 'should get top albums of a given tag' do
      expect(@lastfm).to receive(:request).with('tag.getTopAlbums', {
        :tag => 'Disco',
        :limit => 5,
        :page => nil
      }).and_return(make_response('tag_get_top_albums'))

      albums = @lastfm.tag.get_top_albums(:tag => 'Disco', :limit => 5)
      expect(albums.size).to eq(5)
      expect(albums[0]['name']).to eq('Number Ones')
      expect(albums[0]['url']).to eq('http://www.last.fm/music/Bee+Gees/Number+Ones')
      expect(albums[0]['artist']['name']).to eq('Bee Gees')
      expect(albums[1]['name']).to eq('Gold: Greatest Hits')
    end
  end

  describe '#search' do
    it 'should get all tags related to a given one' do
      expect(@lastfm).to receive(:request).with('tag.search', {
        :tag => 'Disco',
        :limit => 5,
        :page => nil
      }).and_return(make_response('tag_search'))

      tags = @lastfm.tag.search(:tag => 'Disco', :limit => 5)
      expect(tags.size).to eq(5)
      expect(tags[0]['name']).to eq('disco')
      expect(tags[0]['count']).to eq('157207')
      expect(tags[0]['url']).to eq('www.last.fm/tag/disco')
      expect(tags[1]['name']).to eq('italo disco')
    end
  end

  describe '#get_info' do
    it 'should get detailed info of a given tag' do
      expect(@lastfm).to receive(:request).with('tag.getInfo', {
        :tag => 'Disco'
      }).and_return(make_response('tag_get_info'))

      tags = @lastfm.tag.get_info(:tag => 'Disco')
      expect(tags[0]['name']).to eq('disco')
      expect(tags[0]['reach']).to eq('33745')
      expect(tags[0]['url']).to eq('http://www.last.fm/tag/disco')
    end
  end
end
