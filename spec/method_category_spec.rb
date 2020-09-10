require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Lastfm::MethodCategory' do
  before do
    @lastfm = Lastfm.new('xxx', 'yyy')
  end

  it 'should have instance of Lastfm' do
    expect(Lastfm::MethodCategory::Base.new(@lastfm).instance_eval { @lastfm }).to equal(@lastfm)
  end
end
