require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#chart' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Chart' do
    @lastfm.chart.should be_an_instance_of(Lastfm::MethodCategory::Chart)
  end

  describe '#get_hyped_artists' do
    it 'should get hyped artists' do
      @lastfm.should_receive(:request).with('chart.getHypedArtists', {
          :limit => 10,
          :page => 3
      }).and_return(make_response('chart_get_hyped_artists'))

      hyped_artists = @lastfm.chart.get_hyped_artists(:limit => 10, :page => 3)
      hyped_artists.size.should > 1
    end
  end

  describe '#get_hyped_tracks' do
    it 'should get hyped tracks' do
      @lastfm.should_receive(:request).with('chart.getHypedTracks', {
          :limit => 10,
          :page => 3
      }).and_return(make_response('chart_get_hyped_tracks'))

      hyped_tracks = @lastfm.chart.get_hyped_tracks(:limit => 10, :page => 3)
      hyped_tracks.size.should > 1
    end
  end

  describe '#get_loved_tracks' do
    it 'should get loved tracks' do
      @lastfm.should_receive(:request).with('chart.getLovedTracks', {
          :limit => 10,
          :page => 3
      }).and_return(make_response('chart_get_loved_tracks'))

      loved_tracks = @lastfm.chart.get_loved_tracks(:limit => 10, :page => 3)
      loved_tracks.size.should > 1
    end
  end

  describe '#get_top_artists' do
    it 'should get top artists' do
      @lastfm.should_receive(:request).with('chart.getTopArtists', {
          :limit => 10,
          :page => 3
      }).and_return(make_response('chart_get_top_artists'))

      top_artists = @lastfm.chart.get_top_artists(:limit => 10, :page => 3)
      top_artists.size.should > 1
    end
  end

  describe '#get_top_tags' do
    it 'should get top tags' do
      @lastfm.should_receive(:request).with('chart.getTopTags', {
          :limit => 10,
          :page => 3
      }).and_return(make_response('chart_get_top_tags'))

      top_tags = @lastfm.chart.get_top_tags(:limit => 10, :page => 3)
      top_tags.size.should > 1
    end
  end

  describe '#get_top_tracks' do
    it 'should get top tracks' do
      @lastfm.should_receive(:request).with('chart.getTopTracks', {
          :limit => 10,
          :page => 3
      }).and_return(make_response('chart_get_top_tracks'))

      top_tracks = @lastfm.chart.get_top_tracks(:limit => 10, :page => 3)
      top_tracks.size.should > 1
    end
  end
end
