require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#tasteometer' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Tasteometer' do
    expect(@lastfm.tasteometer).to be_an_instance_of(Lastfm::MethodCategory::Tasteometer)
  end

  describe '#compare' do
    it 'should compare users' do
      expect(@lastfm).to receive(:request).with('tasteometer.compare', {
        :type1 => 'user',
        :type2 => 'user',
        :value1 => 'foo',
        :value2 => 'bar',
        :limit => nil
      }).and_return(make_response('tasteometer_compare'))
      compare = @lastfm.tasteometer.compare(:type1 => 'user', :type2 => 'user', :value1 =>'foo', :value2 => 'bar')
      expect(compare['score']).to eq('0.74')
      expect(compare['artists']['artist'][1]['name']).to eq('The Beatles')
    end
  end
end
