require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#library' do
  before { init_lastfm }

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
      tracks = @lastfm.library.get_tracks(:user => 'test', :artist => 'foo', :album => 'bar')
      tracks[0]['name'].should == 'Learning to Live'
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
      artists = @lastfm.library.get_artists(:user => 'test')
      artists[1]['name'].should == 'Dark Castle'
      artists.size.should == 2
    end
  end
end
