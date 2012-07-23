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
end
