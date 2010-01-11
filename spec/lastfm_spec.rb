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
    it 'should post' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, false, false)['bar'].should eql('baz')
    end

    it 'should post with signature' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')
      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, false)['bar'].should eql('baz')
    end

    it 'should post with signature and session (request with authentication)' do
      mock_response = mock(HTTParty::Response)
      @lastfm.session = 'abcdef'
      @lastfm.class.should_receive(:post).with('/', :body => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
          :sk => 'abcdef',
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')

      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :post, true, true)['bar'].should eql('baz')
    end

    it 'should get' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')

      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, false, false)['bar'].should eql('baz')
    end

    it 'should get with signature (request for authentication)' do
      mock_response = mock(HTTParty::Response)
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyyyy'),
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')

      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, false)['bar'].should eql('baz')
    end

    it 'should get with signature and session' do
      mock_response = mock(HTTParty::Response)
      @lastfm.session = 'abcdef'
      @lastfm.class.should_receive(:get).with('/', :query => {
          :foo => 'bar',
          :method => 'xxx.yyy',
          :api_key => 'xxx',
          :api_sig => Digest::MD5.hexdigest('api_keyxxxfoobarmethodxxx.yyyskabcdefyyy'),
          :sk => 'abcdef',
          :format => 'json'
        }).and_return(mock_response)
      mock_response.should_receive(:body).and_return('{ "bar": "baz" }')

      @lastfm.request('xxx.yyy', { :foo => 'bar' }, :get, true, true)['bar'].should eql('baz')
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
      @lastfm.should_receive(:request).
        with('auth.getToken', {}, :get, true).
        and_return({ 'token' => 'xxxyyyzzz' })
      @lastfm.auth.get_token.should eql('xxxyyyzzz')
    end

    it 'should get session' do
      @lastfm.should_receive(:request).
        with('auth.getSession', { :token => 'xxxyyyzzz' }, :get, true).
        and_return({ 'session' => { 'key' => 'zzzyyyxxx' }})
      @lastfm.auth.get_session('xxxyyyzzz').should eql('zzzyyyxxx')
    end
  end

  describe '#track' do
    it 'should return an instance of Lastfm::Track' do
      @lastfm.track.should be_an_instance_of(Lastfm::Track)
    end

    it 'should add tags' do
      @lastfm.should_receive(:request).with('track.addTags', {
          :artist => 'foo artist',
          :track => 'foo track',
          :tags => 'aaa,bbb,ccc'
        }, :post, true, true).and_return({})

      @lastfm.track.add_tags('foo artist', 'foo track', 'aaa,bbb,ccc')
    end

    it 'should ban' do
      @lastfm.should_receive(:request).with('track.ban', {
          :artist => 'foo artist',
          :track => 'foo track',
        }, :post, true, true).and_return({})

      @lastfm.track.ban('foo artist', 'foo track')
    end

    it 'should get info' do
      @lastfm.should_receive(:request).with('track.getInfo', {
          :artist => 'foo artist',
          :track => 'foo track',
          :username => 'youpy',
        }).and_return({})

      @lastfm.track.get_info('foo artist', 'foo track', 'youpy')
    end

    it 'should get similar' do
      @lastfm.should_receive(:request).with('track.getSimilar', {
          :artist => 'foo artist',
          :track => 'foo track',
        }).and_return({})

      @lastfm.track.get_similar('foo artist', 'foo track')
    end

    it 'should get tags' do
      @lastfm.should_receive(:request).with('track.getTags', {
          :artist => 'foo artist',
          :track => 'foo track',
        }, :get, true, true).and_return({})

      @lastfm.track.get_tags('foo artist', 'foo track')
    end

    it 'should get top fans' do
      @lastfm.should_receive(:request).with('track.getTopFans', {
          :artist => 'foo artist',
          :track => 'foo track',
        }).and_return({})

      @lastfm.track.get_top_fans('foo artist', 'foo track')
    end

    it 'should get top tags' do
      @lastfm.should_receive(:request).with('track.getTopTags', {
          :artist => 'foo artist',
          :track => 'foo track',
        }).and_return({})

      @lastfm.track.get_top_tags('foo artist', 'foo track')
    end

    it 'should love' do
      @lastfm.should_receive(:request).with('track.love', {
          :artist => 'foo artist',
          :track => 'foo track',
        }, :post, true, true).and_return({})

      @lastfm.track.love('foo artist', 'foo track')
    end

    it 'should remove tag' do
      @lastfm.should_receive(:request).with('track.removeTag', {
          :artist => 'foo artist',
          :track => 'foo track',
          :tag => 'aaa'
        }, :post, true, true).and_return({})

      @lastfm.track.remove_tag('foo artist', 'foo track', 'aaa')
    end

    it 'should search' do
      @lastfm.should_receive(:request).with('track.search', {
          :artist => 'foo artist',
          :track => 'foo track',
          :limit => 10,
          :page => 3,
        }).and_return({})

      @lastfm.track.search('foo artist', 'foo track', 10, 3)
    end

    it 'should share' do
      @lastfm.should_receive(:request).with('track.share', {
          :artist => 'foo artist',
          :track => 'foo track',
          :message => 'this is a message',
          :recipient => 'foo@example.com',
        }, :post, true, true).and_return({})

      @lastfm.track.share('foo artist', 'foo track', 'foo@example.com', 'this is a message')
    end
  end
end
