require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#radio' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Radio' do
    @lastfm.radio.should be_an_instance_of(Lastfm::MethodCategory::Radio)
  end

  describe '#tune' do
    it 'should tune' do
      @lastfm.should_receive(:request).with('radio.tune', {
        :station => 'lastfm://globaltags/pop',
      }, :post, true, true).and_return(@ok_response)
      @lastfm.radio.tune("lastfm://globaltags/pop")
    end
  end

  describe '#get_playlist' do
    it 'should return some playlist' do
      @lastfm.should_receive(:request).with("radio.getPlaylist", {}, :get, true, true).and_return(make_response('radio_get_playlist'))
      playlist = @lastfm.radio.get_playlist
      tracklist = playlist["trackList"]["track"]
      tracklist.should be_an_instance_of(Array)
      tracklist[0]['title'].should == "All The Things She Said"
      tracklist[1]['location'].should == "http://play.last.fm/user/bca46e434c3389217ef1b8d20db1690c.mp3"
      tracklist[2]['creator'].should == "Culture Club"
      tracklist[3]['album'].should == "The E.N.D."
    end

    it 'should always return playlists with arrays of tracks' do
      @lastfm.should_receive(:request).with("radio.getPlaylist", {}, :get, true, true).and_return(make_response('radio_get_playlist_single_track'))
      playlist = @lastfm.radio.get_playlist
      playlist["trackList"]["track"].should be_an_instance_of(Array)
    end
  end
end

