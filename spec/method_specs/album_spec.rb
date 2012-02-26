require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#album' do
  before do
    init_lastfm
  end

  it 'should return an instance of Lastfm::Album' do
    @lastfm.album.should be_an_instance_of(Lastfm::MethodCategory::Album)
  end

  it 'should get info' do
    @lastfm.should_receive(:request).with('album.getInfo', {
      :artist => 'Cher', :album => 'Believe'
    }).and_return(make_response('album_get_info'))

    album = @lastfm.album.get_info('Cher', 'Believe')
    album['name'].should == 'Believe'
    album['artist'].should == 'Cher'
    album['id'].should == '2026126'
    album['mbid'].should == '61bf0388-b8a9-48f4-81d1-7eb02706dfb0'
    album['url'].should == 'http://www.last.fm/music/Cher/Believe'
    album['image'].size.should == 5
    album['releasedate'].should == '6 Apr 1999, 00:00'
    album['tracks']['track'].size.should == 10
    album['tracks']['track'][0]['name'].should == 'Believe'
    album['tracks']['track'][0]['duration'].should == '239'
    album['tracks']['track'][0]['url'].should == 'http://www.last.fm/music/Cher/_/Believe'
  end
end
