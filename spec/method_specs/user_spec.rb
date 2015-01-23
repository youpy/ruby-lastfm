require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#user' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::User' do
    @lastfm.user.should be_an_instance_of(Lastfm::MethodCategory::User)
  end

  describe '#get_info' do
    context 'with params' do
      it 'should get user info' do
        @lastfm.should_receive(:request).with('user.getInfo', {:user => 'test'}).and_return(make_response('user_get_info'))
        info = @lastfm.user.get_info(:user => 'test')
        info['id'].should == '1000002'
      end
    end

    context 'without params' do
      it 'should get current user info' do
        @lastfm.should_receive(:request).with('user.getInfo', {}, :get, true, true).and_return(make_response('user_get_info'))
        info = @lastfm.user.get_info
        info['id'].should == '1000002'
      end
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

      artists = @lastfm.user.get_top_artists(
        :user => 'test',
        :period => 'overall')

      artists.size.should == 3
      artists[0]['name'].should == 'Pain of Salvation'
      artists[0]['playcount'].should == '1354'

      artists[1]['name'].should == 'Opeth'
      artists[1]['playcount'].should == '1186'

      artists[2]['name'].should == 'Nevermore'
      artists[2]['playcount'].should == '959'
    end
  end

  describe '#get_personal_tags' do
    it 'should get user\'s tagged artists' do
      @lastfm.should_receive(:request).with('user.getPersonalTags', {
        :user => 'test',
        :tag => 'rock',
        :taggingtype => 'artist',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_personal_tags_artists'))

      artists = @lastfm.user.get_personal_tags(
        :user => 'test',
        :tag => 'rock')
      artists[0]['name'].should == 'Afghan Whigs'
      artists[0]['url'].should == 'http://www.last.fm/music/Afghan+Whigs'
      artists[1]['name'].should == 'Jeff The Brotherhood'
      artists.size.should == 5
    end

    it 'should get user\'s tagged albums' do
      @lastfm.should_receive(:request).with('user.getPersonalTags', {
        :user => 'test',
        :tag => 'hip-hop',
        :taggingtype => 'album',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_personal_tags_albums'))

      albums = @lastfm.user.get_personal_tags(
        :user => 'test',
        :tag => 'hip-hop',
        :taggingtype => 'album')
      albums[0]['name'].should == 'DJ Bizkid Presents: The Best of Atmosphere'
      albums.size.should == 1
    end

    it 'should get user\'s tagged tracks' do
      @lastfm.should_receive(:request).with('user.getPersonalTags', {
        :user => 'test',
        :tag => 'jazz',
        :taggingtype => 'track',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_personal_tags_tracks'))

      tracks = @lastfm.user.get_personal_tags(
        :user => 'test',
        :tag => 'jazz',
        :taggingtype => 'track')
      tracks[0]['name'].should == 'Come Together'
      tracks[1]['name'].should == 'Dione'
      tracks[1]['duration'].should == '450'
      tracks.size.should == 5
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

      albums = @lastfm.user.get_top_albums(
        :user => 'test',
        :period => 'overall')

      albums.size.should == 2

      albums[0]['rank'].should == '1'
      albums[0]['name'].should == 'The Wall'
      albums[0]['artist']['name'].should == 'Pink Floyd'

      albums[1]['rank'].should == '2'
      albums[1]['name'].should == 'The Perfect Element, Part I'
      albums[1]['artist']['name'].should == 'Pain of Salvation'
    end
  end

  describe '#get_top_tracks' do
    it 'should get user\'s top tracks' do
      @lastfm.should_receive(:request).with('user.getTopTracks', {
        :user => 'test',
        :period => '7day',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_top_tracks'))

      tracks = @lastfm.user.get_top_tracks(
        :user => 'test',
        :period => '7day')

      tracks.size.should == 2

      tracks[0]['rank'].should == '1'
      tracks[0]['name'].should == 'No Light, No Light (TV On The Radio Remix)'
      tracks[0]['artist']['name'].should == 'Florence + the Machine'

      tracks[1]['rank'].should == '2'
      tracks[1]['name'].should == 'Backwords (Porcelain Raft cover)'
      tracks[1]['artist']['name'].should == 'Oupa & Tony Crow'
    end
  end

  describe '#get_loved_tracks' do
    it 'should get user\'s loved tracks' do
      @lastfm.should_receive(:request).with('user.getLovedTracks', {
        :user => 'test',
        :period => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_loved_tracks'))

      tracks = @lastfm.user.get_loved_tracks(:user => 'test')

      tracks.size.should == 2

      tracks[0]['rank'].should == nil
      tracks[0]['name'].should == 'I Spy'
      tracks[0]['artist']['name'].should == 'Mikhael Paskalev'

      tracks[1]['rank'].should == nil
      tracks[1]['name'].should == 'Working Titles'
      tracks[1]['artist']['name'].should == 'Damien Jurado'
    end

    it 'should always return an array of tracks' do
      @lastfm.should_receive(:request).with('user.getLovedTracks', {
        :user => 'test',
        :period => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_loved_tracks_single_track'))

      tracks = @lastfm.user.get_loved_tracks(:user => 'test')

      tracks.size.should == 1

      tracks[0]['rank'].should == nil
      tracks[0]['name'].should == 'I Spy'
      tracks[0]['artist']['name'].should == 'Mikhael Paskalev'
    end

    it 'should return an empty array when user has 0 loved tracks' do
      @lastfm.should_receive(:request).with('user.getLovedTracks', {
        :user => 'test',
        :period => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_loved_tracks_no_tracks'))

      tracks = @lastfm.user.get_loved_tracks(:user => 'test')

      tracks.size.should == 0
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
      friends = @lastfm.user.get_friends(:user => 'test')
      friends.size.should == 1
      friends[0]['name'].should == 'polaroide'
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
      neighbours = @lastfm.user.get_neighbours(:user => 'rj')
      neighbours.size.should == 5
      neighbours[0]['name'].should == 'willywongi'
    end
  end

  describe '#get_new_releases' do
    it 'should get user\'s new releases' do
      @lastfm.should_receive(:request).with('user.getNewReleases', {
        :user => 'rj',
        :userecs => nil
      }).and_return(make_response('user_get_new_releases'))
      albums = @lastfm.user.get_new_releases(:user => 'rj')
      albums.size.should == 20
      albums[0]['name'].should == 'Ten Redux'
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
      }, :get, true, true).and_return(make_response('user_get_recent_tracks'))
      tracks = @lastfm.user.get_recent_tracks(:user => 'test')
      tracks[1]['artist']['content'].should == 'Kylie Minogue'
      tracks.size.should == 2
    end

    it 'should not error when a user\'s recent tracks includes malformed data' do
      @lastfm.should_receive(:request).with('user.getRecentTracks', {
        :user => 'test',
        :page => nil,
        :limit => nil,
        :to => nil,
        :from => nil
      }, :get, true, true).and_return(make_response('user_get_recent_tracks_malformed'))
      @lastfm.user.get_recent_tracks(:user => 'test')
    end
  end

  describe '#get_top_tags' do
    it 'should get user\'s top tags' do
      @lastfm.should_receive(:request).with('user.getTopTags', {
        :user => 'test',
        :limit => nil
      }).and_return(make_response('user_get_top_tags'))
      tags = @lastfm.user.get_top_tags(:user => 'test')
      tags[0]['name'].should == 'rock'
      tags[0]['count'].should == '19'
      tags[1]['count'].should == '15'
      tags.size.should == 5
    end
  end

  describe '#get_weekly_chart_list' do
    it 'should get user\'s weekly chart list' do
      @lastfm.should_receive(:request).with('user.getWeeklyChartList', {
        :user => 'test',
        :limit => nil,
      }).and_return(make_response('user_get_weekly_chart_list'))
      weekly_charts = @lastfm.user.get_weekly_chart_list(:user => 'test')
      weekly_charts[0]['from'].should == "1108296002"
      weekly_charts[0]['to'].should == "1108900802"
      weekly_charts[1]['from'].should == "1108900801"
      weekly_charts.size.should == 8
    end
  end

  describe '#get_weekly_artist_chart' do
    it 'should get user\'s weekly artist chart' do
      @lastfm.should_receive(:request).with('user.getWeeklyArtistChart', {
        :user => 'test',
        :limit => nil,
        :to => nil,
        :from => nil
      }).and_return(make_response('user_get_weekly_artist_chart'))
      weekly_artists = @lastfm.user.get_weekly_artist_chart(:user => 'test')
      weekly_artists[0]['name'].should == "Leonard Cohen"
      weekly_artists[0]['playcount'].should == "46"
      weekly_artists[1]['playcount'].should == "44"
      weekly_artists.size.should == 4
    end
  end

  describe '#get_weekly_album_chart' do
    it 'should get user\'s weekly album chart' do
      @lastfm.should_receive(:request).with('user.getWeeklyAlbumChart', {
        :user => 'test',
        :limit => nil,
        :to => nil,
        :from => nil
      }).and_return(make_response('user_get_weekly_album_chart'))
      weekly_albums = @lastfm.user.get_weekly_album_chart(:user => 'test')
      weekly_albums[0]['artist']['content'].should == "Leonard Cohen"
      weekly_albums[0]['playcount'].should == "25"
      weekly_albums[1]['playcount'].should == "18"
      weekly_albums.size.should == 3
    end
  end

  describe '#get_weekly_track_chart' do
    it 'should get user\'s weekly track chart' do
      @lastfm.should_receive(:request).with('user.getWeeklyTrackChart', {
        :user => 'test',
        :limit => nil,
        :to => nil,
        :from => nil
      }).and_return(make_response('user_get_weekly_track_chart'))
      weekly_tracks = @lastfm.user.get_weekly_track_chart(:user => 'test')
      weekly_tracks[0]['artist']['content'].should == "Tori Amos"
      weekly_tracks[0]['playcount'].should == "2"
      weekly_tracks[1]['playcount'].should == "2"
      weekly_tracks.size.should == 3
    end
  end

  describe '#get_recommended_events' do
    it 'should get a user\'s list of recommended events' do
      @lastfm.should_receive(:request).with('user.getRecommendedEvents', {}, :get, true, true) {
        make_response('user_get_recommended_events') }

      recommended_events = @lastfm.user.get_recommended_events
      recommended_events[0]['artists']['headliner'].should == 'Toro y Moi'
      recommended_events[1]['artists']['headliner'].should == 'Reel Big Fish'
    end
  end

  describe '#get_recommended_artists' do
    it 'shoud get user\'s recommended artists' do
      @lastfm.should_receive(:request).with('user.getRecommendedArtists', {}, :get, true, true) {
        make_response('user_get_recommended_artists') }

      recommended_artists = @lastfm.user.get_recommended_artists
      recommended_artists[0]['name'].should == 'Quest.Room.Project'
      recommended_artists[1]['name'].should == 'Senior Soul'
    end
  end
end
