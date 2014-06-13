require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#tag' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Tag' do
    @lastfm.tag.should be_an_instance_of(Lastfm::MethodCategory::Tag)
  end

  describe '#get_top_artists' do
    it 'should get top artists of some tag' do
      @lastfm.should_receive(:request).with('tag.getTopArtists', {
        :tag => 'Disco',
        :limit => nil,
        :page => nil
      }).and_return(make_response('tag_get_top_artists'))

      artists = @lastfm.tag.get_top_artists(:tag => 'Disco')
      artists.size.should == 5
      artists[0]['name'].should == 'Bee Gees'
      artists[0]['url'].should == 'http://www.last.fm/music/Bee+Gees'
      artists[1]['name'].should == 'ABBA'
    end
  end

  describe '#get_top_tracks' do
    it 'should get top tracks of a given tag' do
      @lastfm.should_receive(:request).with('tag.getTopTracks', {
        :tag => 'Disco',
        :limit => 5,
        :page => nil
      }).and_return(make_response('tag_get_top_tracks'))

      tracks = @lastfm.tag.get_top_tracks(:tag => 'Disco', :limit => 5)
      tracks.size.should == 5
      tracks[0]['name'].should == 'Stayin\' Alive'
      tracks[0]['url'].should == 'http://www.last.fm/music/Bee+Gees/_/Stayin%27+Alive'
      tracks[0]['artist']['name'].should == 'Bee Gees'
      tracks[1]['name'].should == 'September'
    end
  end

  describe '#get_top_albums' do
    it 'should get top albums of a given tag' do
      @lastfm.should_receive(:request).with('tag.getTopAlbums', {
        :tag => 'Disco',
        :limit => 5,
        :page => nil
      }).and_return(make_response('tag_get_top_albums'))

      albums = @lastfm.tag.get_top_albums(:tag => 'Disco', :limit => 5)
      albums.size.should == 5
      albums[0]['name'].should == 'Number Ones'
      albums[0]['url'].should == 'http://www.last.fm/music/Bee+Gees/Number+Ones'
      albums[0]['artist']['name'].should == 'Bee Gees'
      albums[1]['name'].should == 'Gold: Greatest Hits'
    end
  end

  describe '#search' do
    it 'should get all tags related to a given one' do
      @lastfm.should_receive(:request).with('tag.search', {
        :tag => 'Disco',
        :limit => 5,
        :page => nil
      }).and_return(make_response('tag_search'))

      tags = @lastfm.tag.search(:tag => 'Disco', :limit => 5)
      tags.size.should == 5
      tags[0]['name'].should == 'disco'
      tags[0]['count'].should == '157207'
      tags[0]['url'].should == 'www.last.fm/tag/disco'
      tags[1]['name'].should == 'italo disco'
    end
  end

  describe '#get_info' do
    it 'should get detailed info of a given tag' do
      @lastfm.should_receive(:request).with('tag.getInfo', {
        :tag => 'Disco'
      }).and_return(make_response('tag_get_info'))

      tags = @lastfm.tag.get_info(:tag => 'Disco')
      tags[0]['name'].should == 'disco'
      tags[0]['reach'].should == '33745'
      tags[0]['url'].should == 'http://www.last.fm/tag/disco'
    end
  end
end
