require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lastfm::Response" do
  before do
    @ok = open(fixture('ok.xml')).read
    @ng = open(fixture('ng.xml')).read
  end

  describe '.new' do
    it 'should instantiate' do
      Lastfm::Response.new(@ok).should be_an_instance_of(Lastfm::Response)
    end
  end

  describe 'success' do
    before do
      @response = Lastfm::Response.new(@ok)
    end

    it 'should be success' do
      @response.should be_success
    end

    it 'should parse response body as xml' do
      xml = @response.xml
      xml['similartracks']['track'].size.should eql(7)
    end
  end

  describe 'failure' do
    before do
      @response = Lastfm::Response.new(@ng)
    end

    it 'should not be success' do
      @response.should_not be_success
    end

    it 'should have message' do
      @response.message.should eql('Invalid API key - You must be granted a valid key by last.fm')
    end

    it 'should have error number' do
      @response.error.should eql(10)
    end
  end
end
