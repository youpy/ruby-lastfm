require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#user' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::User' do
    expect(@lastfm.user).to be_an_instance_of(Lastfm::MethodCategory::User)
  end

  describe '#get_info' do
    context 'with params' do
      it 'should get user info' do
        expect(@lastfm).to receive(:request).with('user.getInfo', {:user => 'test'}).and_return(make_response('user_get_info'))
        info = @lastfm.user.get_info(:user => 'test')
        expect(info['id']).to eq('1000002')
      end
    end

    context 'without params' do
      it 'should get current user info' do
        expect(@lastfm).to receive(:request).with('user.getInfo', {}, :get, true, true).and_return(make_response('user_get_info'))
        info = @lastfm.user.get_info
        expect(info['id']).to eq('1000002')
      end
    end
  end

  describe '#get_top_artists' do
    it 'should get user\'s top artists' do
      expect(@lastfm).to receive(:request).with('user.getTopArtists', {
        :user => 'test',
        :period => 'overall',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_top_artists'))

      artists = @lastfm.user.get_top_artists(
        :user => 'test',
        :period => 'overall')

      expect(artists.size).to eq(3)
      expect(artists[0]['name']).to eq('Pain of Salvation')
      expect(artists[0]['playcount']).to eq('1354')

      expect(artists[1]['name']).to eq('Opeth')
      expect(artists[1]['playcount']).to eq('1186')

      expect(artists[2]['name']).to eq('Nevermore')
      expect(artists[2]['playcount']).to eq('959')
    end
  end

  describe '#get_personal_tags' do
    it 'should get user\'s tagged artists' do
      expect(@lastfm).to receive(:request).with('user.getPersonalTags', {
        :user => 'test',
        :tag => 'rock',
        :taggingtype => 'artist',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_personal_tags_artists'))

      artists = @lastfm.user.get_personal_tags(
        :user => 'test',
        :tag => 'rock')
      expect(artists[0]['name']).to eq('Afghan Whigs')
      expect(artists[0]['url']).to eq('http://www.last.fm/music/Afghan+Whigs')
      expect(artists[1]['name']).to eq('Jeff The Brotherhood')
      expect(artists.size).to eq(5)
    end

    it 'should get user\'s tagged albums' do
      expect(@lastfm).to receive(:request).with('user.getPersonalTags', {
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
      expect(albums[0]['name']).to eq('DJ Bizkid Presents: The Best of Atmosphere')
      expect(albums.size).to eq(1)
    end

    it 'should get user\'s tagged tracks' do
      expect(@lastfm).to receive(:request).with('user.getPersonalTags', {
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
      expect(tracks[0]['name']).to eq('Come Together')
      expect(tracks[1]['name']).to eq('Dione')
      expect(tracks[1]['duration']).to eq('450')
      expect(tracks.size).to eq(5)
    end
  end

  describe '#get_top_albums' do
    it 'should get user\'s top albums' do
      expect(@lastfm).to receive(:request).with('user.getTopAlbums', {
        :user => 'test',
        :period => 'overall',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_top_albums'))

      albums = @lastfm.user.get_top_albums(
        :user => 'test',
        :period => 'overall')

      expect(albums.size).to eq(2)

      expect(albums[0]['rank']).to eq('1')
      expect(albums[0]['name']).to eq('The Wall')
      expect(albums[0]['artist']['name']).to eq('Pink Floyd')

      expect(albums[1]['rank']).to eq('2')
      expect(albums[1]['name']).to eq('The Perfect Element, Part I')
      expect(albums[1]['artist']['name']).to eq('Pain of Salvation')
    end
  end

  describe '#get_top_tracks' do
    it 'should get user\'s top tracks' do
      expect(@lastfm).to receive(:request).with('user.getTopTracks', {
        :user => 'test',
        :period => '7day',
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_top_tracks'))

      tracks = @lastfm.user.get_top_tracks(
        :user => 'test',
        :period => '7day')

      expect(tracks.size).to eq(2)

      expect(tracks[0]['rank']).to eq('1')
      expect(tracks[0]['name']).to eq('No Light, No Light (TV On The Radio Remix)')
      expect(tracks[0]['artist']['name']).to eq('Florence + the Machine')

      expect(tracks[1]['rank']).to eq('2')
      expect(tracks[1]['name']).to eq('Backwords (Porcelain Raft cover)')
      expect(tracks[1]['artist']['name']).to eq('Oupa & Tony Crow')
    end
  end

  describe '#get_loved_tracks' do
    it 'should get user\'s loved tracks' do
      expect(@lastfm).to receive(:request).with('user.getLovedTracks', {
        :user => 'test',
        :period => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_loved_tracks'))

      tracks = @lastfm.user.get_loved_tracks(:user => 'test')

      expect(tracks.size).to eq(2)

      expect(tracks[0]['rank']).to eq(nil)
      expect(tracks[0]['name']).to eq('I Spy')
      expect(tracks[0]['artist']['name']).to eq('Mikhael Paskalev')

      expect(tracks[1]['rank']).to eq(nil)
      expect(tracks[1]['name']).to eq('Working Titles')
      expect(tracks[1]['artist']['name']).to eq('Damien Jurado')
    end

    it 'should always return an array of tracks' do
      expect(@lastfm).to receive(:request).with('user.getLovedTracks', {
        :user => 'test',
        :period => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_loved_tracks_single_track'))

      tracks = @lastfm.user.get_loved_tracks(:user => 'test')

      expect(tracks.size).to eq(1)

      expect(tracks[0]['rank']).to eq(nil)
      expect(tracks[0]['name']).to eq('I Spy')
      expect(tracks[0]['artist']['name']).to eq('Mikhael Paskalev')
    end

    it 'should return an empty array when user has 0 loved tracks' do
      expect(@lastfm).to receive(:request).with('user.getLovedTracks', {
        :user => 'test',
        :period => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('user_get_loved_tracks_no_tracks'))

      tracks = @lastfm.user.get_loved_tracks(:user => 'test')

      expect(tracks.size).to eq(0)
    end
  end

  describe '#get_friends' do
    it 'should get user\'s friends' do
      expect(@lastfm).to receive(:request).with('user.getFriends', {
        :user => 'test',
        :recenttracks => nil,
        :page => nil,
        :limit => nil
      }).and_return(make_response('user_get_friends'))
      friends = @lastfm.user.get_friends(:user => 'test')
      expect(friends.size).to eq(1)
      expect(friends[0]['name']).to eq('polaroide')
    end
  end

  describe '#get_neighbours' do
    it 'should get user\'s neighbours' do
      expect(@lastfm).to receive(:request).with('user.getNeighbours', {
        :user => 'rj',
        :recenttracks => nil,
        :page => nil,
        :limit => nil
      }).and_return(make_response('user_get_neighbours'))
      neighbours = @lastfm.user.get_neighbours(:user => 'rj')
      expect(neighbours.size).to eq(5)
      expect(neighbours[0]['name']).to eq('willywongi')
    end
  end

  describe '#get_new_releases' do
    it 'should get user\'s new releases' do
      expect(@lastfm).to receive(:request).with('user.getNewReleases', {
        :user => 'rj',
        :userecs => nil
      }).and_return(make_response('user_get_new_releases'))
      albums = @lastfm.user.get_new_releases(:user => 'rj')
      expect(albums.size).to eq(20)
      expect(albums[0]['name']).to eq('Ten Redux')
    end
  end

  describe '#get_recent_tracks' do
    it 'should get user\'s recent tracks' do
      expect(@lastfm).to receive(:request).with('user.getRecentTracks', {
        :user => 'test',
        :page => nil,
        :limit => nil,
        :to => nil,
        :from => nil
      }, :get, true, true).and_return(make_response('user_get_recent_tracks'))
      tracks = @lastfm.user.get_recent_tracks(:user => 'test')
      expect(tracks[1]['artist']['content']).to eq('Kylie Minogue')
      expect(tracks.size).to eq(2)
    end

    it 'should not error when a user\'s recent tracks includes malformed data' do
      expect(@lastfm).to receive(:request).with('user.getRecentTracks', {
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
      expect(@lastfm).to receive(:request).with('user.getTopTags', {
        :user => 'test',
        :limit => nil
      }).and_return(make_response('user_get_top_tags'))
      tags = @lastfm.user.get_top_tags(:user => 'test')
      expect(tags[0]['name']).to eq('rock')
      expect(tags[0]['count']).to eq('19')
      expect(tags[1]['count']).to eq('15')
      expect(tags.size).to eq(5)
    end
  end

  describe '#get_weekly_chart_list' do
    it 'should get user\'s weekly chart list' do
      expect(@lastfm).to receive(:request).with('user.getWeeklyChartList', {
        :user => 'test',
        :limit => nil,
      }).and_return(make_response('user_get_weekly_chart_list'))
      weekly_charts = @lastfm.user.get_weekly_chart_list(:user => 'test')
      expect(weekly_charts[0]['from']).to eq("1108296002")
      expect(weekly_charts[0]['to']).to eq("1108900802")
      expect(weekly_charts[1]['from']).to eq("1108900801")
      expect(weekly_charts.size).to eq(8)
    end
  end

  describe '#get_weekly_artist_chart' do
    it 'should get user\'s weekly artist chart' do
      expect(@lastfm).to receive(:request).with('user.getWeeklyArtistChart', {
        :user => 'test',
        :limit => nil,
        :to => nil,
        :from => nil
      }).and_return(make_response('user_get_weekly_artist_chart'))
      weekly_artists = @lastfm.user.get_weekly_artist_chart(:user => 'test')
      expect(weekly_artists[0]['name']).to eq("Leonard Cohen")
      expect(weekly_artists[0]['playcount']).to eq("46")
      expect(weekly_artists[1]['playcount']).to eq("44")
      expect(weekly_artists.size).to eq(4)
    end
  end

  describe '#get_weekly_album_chart' do
    it 'should get user\'s weekly album chart' do
      expect(@lastfm).to receive(:request).with('user.getWeeklyAlbumChart', {
        :user => 'test',
        :limit => nil,
        :to => nil,
        :from => nil
      }).and_return(make_response('user_get_weekly_album_chart'))
      weekly_albums = @lastfm.user.get_weekly_album_chart(:user => 'test')
      expect(weekly_albums[0]['artist']['content']).to eq("Leonard Cohen")
      expect(weekly_albums[0]['playcount']).to eq("25")
      expect(weekly_albums[1]['playcount']).to eq("18")
      expect(weekly_albums.size).to eq(3)
    end
  end

  describe '#get_weekly_track_chart' do
    it 'should get user\'s weekly track chart' do
      expect(@lastfm).to receive(:request).with('user.getWeeklyTrackChart', {
        :user => 'test',
        :limit => nil,
        :to => nil,
        :from => nil
      }).and_return(make_response('user_get_weekly_track_chart'))
      weekly_tracks = @lastfm.user.get_weekly_track_chart(:user => 'test')
      expect(weekly_tracks[0]['artist']['content']).to eq("Tori Amos")
      expect(weekly_tracks[0]['playcount']).to eq("2")
      expect(weekly_tracks[1]['playcount']).to eq("2")
      expect(weekly_tracks.size).to eq(3)
    end
  end

  describe '#get_recommended_events' do
    it 'should get a user\'s list of recommended events' do
      expect(@lastfm).to receive(:request).with('user.getRecommendedEvents', {}, :get, true, true) {
        make_response('user_get_recommended_events') }

      recommended_events = @lastfm.user.get_recommended_events
      expect(recommended_events[0]['artists']['headliner']).to eq('Toro y Moi')
      expect(recommended_events[1]['artists']['headliner']).to eq('Reel Big Fish')
    end
  end

  describe '#get_recommended_artists' do
    it 'shoud get user\'s recommended artists' do
      expect(@lastfm).to receive(:request).with('user.getRecommendedArtists', {}, :get, true, true) {
        make_response('user_get_recommended_artists') }

      recommended_artists = @lastfm.user.get_recommended_artists
      expect(recommended_artists[0]['name']).to eq('Quest.Room.Project')
      expect(recommended_artists[1]['name']).to eq('Senior Soul')
    end
  end
end
