require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#user' do
  before do
    init_lastfm
  end

  it 'should return an instance of Lastfm::User' do
    @lastfm.user.should be_an_instance_of(Lastfm::MethodCategory::User)
  end

  describe '#get_info' do
    it 'should get user info' do
      @lastfm.should_receive(:request).with('user.getInfo', {:user => 'test'}).and_return(make_response('user_get_info'))
      info = @lastfm.user.get_info('test')
      info['id'].should == '1000002'
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

      artists = @lastfm.user.get_top_artists('test', 'overall', nil, nil)

      artists.size.should == 3
      artists[0]['name'].should == 'Pain of Salvation'
      artists[0]['playcount'].should == '1354'

      artists[1]['name'].should == 'Opeth'
      artists[1]['playcount'].should == '1186'

      artists[2]['name'].should == 'Nevermore'
      artists[2]['playcount'].should == '959'
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

      albums = @lastfm.user.get_top_albums('test', 'overall', nil, nil)

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

      tracks = @lastfm.user.get_top_tracks('test', '7day', nil, nil)

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

      tracks = @lastfm.user.get_loved_tracks('test', nil, nil, nil)

      tracks.size.should == 2

      tracks[0]['rank'].should == nil
      tracks[0]['name'].should == 'I Spy'
      tracks[0]['artist']['name'].should == 'Mikhael Paskalev'

      tracks[1]['rank'].should == nil
      tracks[1]['name'].should == 'Working Titles'
      tracks[1]['artist']['name'].should == 'Damien Jurado'
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
      friends = @lastfm.user.get_friends('test')
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
      neighbours = @lastfm.user.get_neighbours('rj')
      neighbours.size.should == 5
      neighbours[0]['name'].should == 'willywongi'
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
      }).and_return(make_response('user_get_recent_tracks'))
      tracks = @lastfm.user.get_recent_tracks('test')
      tracks[1]['artist']['content'].should == 'Kylie Minogue'
      tracks.size.should == 2
    end
  end
  
  describe '#get_top_tags' do
    it 'should get user\'s top tags' do
      @lastfm.should_receive(:request).with('user.getTopTags', {
        :user => 'test',
        :limit => nil
      }).and_return(make_response('user_get_top_tags'))
      tags = @lastfm.user.get_top_tags('test')
      tags[0]['name'].should == 'rock'
      tags[0]['count'].should == '19'
      tags[1]['count'].should == '15'
      tags.size.should == 5
    end
  end
end
