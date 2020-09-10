require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Lastfm::Response' do
  before do
    @ok = open(fixture('ok.xml')).read
    @ng = open(fixture('ng.xml')).read
  end

  describe '.new' do
    it 'should instantiate' do
      expect(Lastfm::Response.new(@ok)).to be_an_instance_of(Lastfm::Response)
    end
  end

  describe 'success' do
    before do
      @response = Lastfm::Response.new(@ok)
    end

    it 'should be success' do
      expect(@response).to be_success
    end

    it 'should parse response body as xml' do
      xml = @response.xml
      expect(xml['similartracks']['track'].size).to eq(7)
    end
  end

  describe 'failure' do
    before do
      @response = Lastfm::Response.new(@ng)
    end

    it 'should not be success' do
      expect(@response).not_to be_success
    end

    it 'should have message' do
      expect(@response.message).to eq('Invalid API key - You must be granted a valid key by last.fm')
    end

    it 'should have error number' do
      expect(@response.error).to eq(10)
    end
  end
end
