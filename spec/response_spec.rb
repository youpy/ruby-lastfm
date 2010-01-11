require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lastfm::Response" do
  describe '.new' do
    it 'should instantiate' do
      Lastfm::Response.new('{ "foo": "bar" }').should be_an_instance_of(Lastfm::Response)
    end
  end

  describe 'success' do
    before do
      @response = Lastfm::Response.new('{ "foo": "bar" }')
    end

    it 'should be success' do
      @response.should be_success
    end

    it 'should parse response body as json' do
      @response['foo'].should eql('bar')
    end

    it 'should ignore unexpected xml response' do
       Lastfm::Response.new('<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
</lfm>
').should be_success
     end
  end

  describe 'failure' do
    before do
      @response = Lastfm::Response.new('{"message": "Invalid Method - No method with that name in this package", "error": 3}')
    end

    it 'should not be success' do
      @response.should_not be_success
    end

    it 'should have message' do
      @response.message.should eql('Invalid Method - No method with that name in this package')
    end

    it 'should have error number' do
      @response.error.should eql(3)
    end
  end
end
