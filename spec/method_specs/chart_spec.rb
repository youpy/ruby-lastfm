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
end
