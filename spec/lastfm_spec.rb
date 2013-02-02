require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lastfm" do
  before { init_lastfm }

  describe '.new' do
    it 'should instantiate' do
      @lastfm.should be_an_instance_of(Lastfm)
    end
  end

  describe '#request' do
    it 'should post' do
      mock_response = mock(HTTParty::Response)
      HTTPRequest.should_receive(:post).with('/', :body => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
      }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, false, false)
    end

    it 'should post with signature' do
      mock_response = mock(HTTParty::Response)
      HTTPRequest.should_receive(:post).with('/', :body => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
      }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, false)
    end

    it 'should post with signature and session (request with authentication)' do
      mock_response = mock(HTTParty::Response)
      @lastfm.session = 'abcdef'
      HTTPRequest.should_receive(:post).with('/', :body => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
        :sk => 'abcdef',
      }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, true)
    end

    it 'should get' do
      mock_response = mock(HTTParty::Response)
      HTTPRequest.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, false, false)
    end

    it 'should get with signature (request for authentication)' do
      mock_response = mock(HTTParty::Response)
      HTTPRequest.should_receive(:get).with('/', :query => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
      }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, false)
    end

    it 'should get with signature and session' do
      mock_response = mock(HTTParty::Response)
      @lastfm.session = 'abcdef'
      HTTPRequest.should_receive(:get).with('/', :query => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
        :sk => 'abcdef',
      }).and_return(mock_response)
      mock_response.should_receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, true)
    end

    it 'should raise an error if an api error is ocuured' do
      mock_response = mock(HTTParty::Response)
      mock_response.should_receive(:body).and_return(open(fixture('ng.xml')).read)
      HTTPRequest.should_receive(:post).and_return(mock_response)

      lambda {
        @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post)
      }.should raise_error(Lastfm::ApiError, 'Invalid API key - You must be granted a valid key by last.fm') {|error|
        error.code.should == 10
      }
    end
  end

  describe '#auth' do
    it 'should return an instance of Lastfm::Auth' do
      @lastfm.auth.should be_an_instance_of(Lastfm::MethodCategory::Auth)
    end

    it 'should get token' do
      @lastfm.should_receive(:request).
        with('auth.getToken', {}, :get, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
<token>xxxyyyzzz</token></lfm>
XML

      @lastfm.auth.get_token.should == 'xxxyyyzzz'
    end

    it 'should get session' do
      @lastfm.should_receive(:request).
        with('auth.getSession', { :token => 'xxxyyyzzz' }, :get, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
	<session>
		<name>MyLastFMUsername</name>
		<key>zzzyyyxxx</key>
		<subscriber>0</subscriber>
	</session>
</lfm>
XML
      session = @lastfm.auth.get_session('xxxyyyzzz')
      session['name'].should == 'MyLastFMUsername'
      session['key'].should == 'zzzyyyxxx'
    end

    it 'should get mobile session' do
      @lastfm.should_receive(:request).
        with('auth.getMobileSession', { :username => 'xxxyyyzzz', :password => 'sekretz' }, :post, true, false, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
	<session>
		<name>MyLastFMUsername</name>
		<key>zzzyyyxxx</key>
		<subscriber>0</subscriber>
	</session>
</lfm>
XML
      session = @lastfm.auth.get_mobile_session('xxxyyyzzz', 'sekretz')
      session['name'].should == 'MyLastFMUsername'
      session['key'].should == 'zzzyyyxxx'
    end
  end
end
