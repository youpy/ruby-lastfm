require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lastfm" do
  before do
    @lastfm = Lastfm.new('xxx', 'yyy')
  end

  it 'should have base_uri' do
    Lastfm.base_uri.should eql('http://ws.audioscrobbler.com/2.0')
  end

  describe '.new' do
    it 'should instantiate' do
      @lastfm.should be_an_instance_of(Lastfm)
    end
  end

  describe '#request' do
    it 'should do post request' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post)['bar'].should eql('baz')
    end

    it 'should do get request' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get)['bar'].should eql('baz')
    end

    it 'should raise an error if an api error is ocuured' do
      mock_response = mock(HTTParty::Response)
      mock_response.should_receive(:body).and_return('{"message": "Invalid Method - No method with that name in this package", "error": 3}')
      @lastfm.class.should_receive(:post).and_return(mock_response)

      lambda {
        @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post)
      }.should raise_error(Lastfm::ApiError, 'Invalid Method - No method with that name in this package')
    end
  end

  describe '#auth' do
    it 'should return an instance of Lastfm::Auth' do
      @lastfm.auth.should be_an_instance_of(Lastfm::Auth)
    end

    it 'should get token' do
      @lastfm.should_receive(:request).with('auth.getToken').and_return({ 'token' => 'xxxyyyzzz' })
      @lastfm.auth.get_token.should eql('xxxyyyzzz')
    end

    it 'should get session' do
      @lastfm.should_receive(:request).
        with('auth.getSession', { :token => 'xxxyyyzzz' }).
        and_return({ 'session' => { 'key' => 'zzzyyyxxx' }})
      @lastfm.auth.get_session('xxxyyyzzz').should eql('zzzyyyxxx')
    end
  end

  describe '#track' do
    it 'should return an instance of Lastfm::Track' do
      @lastfm.track.should be_an_instance_of(Lastfm::Track)
    end

    it 'should love' do
      @lastfm.session = 'abcdef'
      @lastfm.should_receive(:request).with('track.love', {
          :artist => 'foo artist',
          :track => 'foo track',
          :sk => 'abcdef'
        }, :post).and_return({ 'status' => 'ok' })

      @lastfm.track.love('foo artist', 'foo track')
    end
  end
end
