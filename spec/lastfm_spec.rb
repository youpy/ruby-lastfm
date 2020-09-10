require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lastfm" do
  before { init_lastfm }

  describe '.new' do
    it 'should instantiate' do
      expect(@lastfm).to be_an_instance_of(Lastfm)
    end
  end

  describe '#request' do
    it 'should post' do
      mock_response = double(HTTParty::Response)
      expect(HTTPRequest).to receive(:post).with('/', :body => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
      }).and_return(mock_response)
      expect(mock_response).to receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, false, false)
    end

    it 'should post with signature' do
      mock_response = double(HTTParty::Response)
      expect(HTTPRequest).to receive(:post).with('/', :body => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
      }).and_return(mock_response)
      expect(mock_response).to receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, false)
    end

    it 'should post with signature and session (request with authentication)' do
      mock_response = double(HTTParty::Response)
      @lastfm.session = 'abcdef'
      expect(HTTPRequest).to receive(:post).with('/', :body => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
        :sk => 'abcdef',
      }).and_return(mock_response)
      expect(mock_response).to receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, true)
    end

    it 'should get' do
      mock_response = double(HTTParty::Response)
      expect(HTTPRequest).to receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
        }).and_return(mock_response)
      expect(mock_response).to receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, false, false)
    end

    it 'should get with signature (request for authentication)' do
      mock_response = double(HTTParty::Response)
      expect(HTTPRequest).to receive(:get).with('/', :query => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
      }).and_return(mock_response)
      expect(mock_response).to receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, false)
    end

    it 'should get with signature and session' do
      mock_response = double(HTTParty::Response)
      @lastfm.session = 'abcdef'
      expect(HTTPRequest).to receive(:get).with('/', :query => {
        :foo => 'bar',
        :method => 'xxx.yyy',
        :api_key => 'xxx',
        :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
        :sk => 'abcdef',
      }).and_return(mock_response)
      expect(mock_response).to receive(:body).and_return(@response_xml)
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, true)
    end

    it 'should raise an error if an api error is ocuured' do
      mock_response = double(HTTParty::Response)
      expect(mock_response).to receive(:body).and_return(open(fixture('ng.xml')).read)
      expect(HTTPRequest).to receive(:post).and_return(mock_response)

      expect {
        @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post)
      }.to raise_error(Lastfm::ApiError, 'Invalid API key - You must be granted a valid key by last.fm') {|error|
        expect(error.code).to eq(10)
      }
    end
  end

  describe '#auth' do
    it 'should return an instance of Lastfm::Auth' do
      expect(@lastfm.auth).to be_an_instance_of(Lastfm::MethodCategory::Auth)
    end

    it 'should get token' do
      expect(@lastfm).to receive(:request).
        with('auth.getToken', {}, :get, true).
        and_return(make_response(<<XML))
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
<token>xxxyyyzzz</token></lfm>
XML

      expect(@lastfm.auth.get_token).to eq('xxxyyyzzz')
    end

    it 'should get session' do
      expect(@lastfm).to receive(:request).
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
      expect(session['name']).to eq('MyLastFMUsername')
      expect(session['key']).to eq('zzzyyyxxx')
    end

    it 'should get mobile session' do
      expect(@lastfm).to receive(:request).
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
      expect(session['name']).to eq('MyLastFMUsername')
      expect(session['key']).to eq('zzzyyyxxx')
    end
  end
end
