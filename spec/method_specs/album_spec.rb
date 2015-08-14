# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#album' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Album' do
    @lastfm.album.should be_an_instance_of(Lastfm::MethodCategory::Album)
  end

  describe '#add_tags' do
    it 'should add tags' do
      @lastfm.should_receive(:request).with('album.addTags', {
        :artist => 'foo artist',
        :album => 'foo track',
        :tags => 'aaa,bbb,ccc'
      }, :post, true, true).and_return(@ok_response)

      @lastfm.album.add_tags(
        :artist => 'foo artist',
        :album => 'foo track',
        :tags => 'aaa,bbb,ccc'
        ).should be_true
    end
  end

  describe '#get_buylinks' do
    it 'should get buylinks' do
      @lastfm.should_receive(:request).with('album.getBuylinks', {
        :artist => 'radiohead',
        :album => 'in rainbows',
        :country => 'united kingdom',
        :autocorrect => nil
      }).and_return(make_response('album_get_buylinks'))

      buylinks = @lastfm.album.get_buylinks(
        :artist => 'radiohead',
        :album => 'in rainbows',
        :country => 'united kingdom'
      )

      buylinks['physicals'].size.should == 1
      buylinks['physicals']['affiliation']['supplierName'].should == 'Amazon'
      buylinks['physicals']['affiliation']['price']['currency'].should == 'GBP'
      buylinks['physicals']['affiliation']['price']['amount'].should == '6.34'
      buylinks['physicals']['affiliation']['price']['formatted'].should == '£6.34'
      buylinks['physicals']['affiliation']['buyLink'].should == 'http://www.last.fm/affiliate/byid/8/3418994/1/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc'

      buylinks['downloads'].size.should == 1
      buylinks['downloads']['affiliation']['supplierName'].should == 'Amazon MP3'
      buylinks['downloads']['affiliation']['price']['currency'].should == 'GBP'
      buylinks['downloads']['affiliation']['price']['amount'].should == '7.99'
      buylinks['downloads']['affiliation']['price']['formatted'].should == '£7.99'
      buylinks['downloads']['affiliation']['buyLink'].should == 'http://www.last.fm/affiliate/byid/8/3418994/44/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc'
    end
    
    it 'should get buylinks by mbid' do
      @lastfm.should_receive(:request).with('album.getBuylinks', {
        :mbid => 'radiohead',
        :country => 'united kingdom',
        :autocorrect => nil
      }).and_return(make_response('album_get_buylinks'))

      buylinks = @lastfm.album.get_buylinks(
        :mbid => 'radiohead',
        :country => 'united kingdom'
      )

      buylinks['physicals'].size.should == 1
      buylinks['physicals']['affiliation']['supplierName'].should == 'Amazon'
      buylinks['physicals']['affiliation']['price']['currency'].should == 'GBP'
      buylinks['physicals']['affiliation']['price']['amount'].should == '6.34'
      buylinks['physicals']['affiliation']['price']['formatted'].should == '£6.34'
      buylinks['physicals']['affiliation']['buyLink'].should == 'http://www.last.fm/affiliate/byid/8/3418994/1/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc'

      buylinks['downloads'].size.should == 1
      buylinks['downloads']['affiliation']['supplierName'].should == 'Amazon MP3'
      buylinks['downloads']['affiliation']['price']['currency'].should == 'GBP'
      buylinks['downloads']['affiliation']['price']['amount'].should == '7.99'
      buylinks['downloads']['affiliation']['price']['formatted'].should == '£7.99'
      buylinks['downloads']['affiliation']['buyLink'].should == 'http://www.last.fm/affiliate/byid/8/3418994/44/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc'
    end

    it 'should raise ArgumentError without country' do
      expect {@lastfm.album.get_buylinks(
        :artist => 'radiohead',
        :album => 'in rainbows'
      )}.to raise_error(ArgumentError)

      expect {@lastfm.album.get_buylinks(
        :mbid => 'radiohead',
      )}.to raise_error(ArgumentError)
    end
  end

  describe '#get_info' do
    it 'should get info by artist and album' do
      @lastfm.should_receive(:request).with('album.getInfo', {
        :artist => 'Cher', :album => 'Believe'
      }).and_return(make_response('album_get_info'))

      album = @lastfm.album.get_info(:artist => 'Cher', :album => 'Believe')
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

    it 'should get info by mbid' do
      @lastfm.should_receive(:request).with('album.getInfo', {
        :mbid => 'xxxxx'
      }).and_return(make_response('album_get_info'))

      album = @lastfm.album.get_info(:mbid => 'xxxxx')
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
    
    it 'works without release date' do
      @lastfm.should_receive(:request).with('album.getInfo', {
        :mbid => 'xxxxx'
      }).and_return(make_response('album_get_info_without_release_date'))

      album = @lastfm.album.get_info(:mbid => 'xxxxx')
      album['name'].should == 'Believe'
    end
  end

  describe '#get_shouts' do
    it 'should get shouts' do
      @lastfm.should_receive(:request).with('album.getShouts', {
        :artist => 'Cher',
        :album => 'Believe',
        :autocorrect => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('album_get_shouts'))

      shouts = @lastfm.album.get_shouts(
        :artist => 'Cher',
        :album => 'Believe')
      shouts.size.should == 2
      shouts[0]['body'].should == 'A perfect Pop/Dance Masterpiece'
      shouts[0]['author'].should == 'top20fanatico'
      shouts[0]['date'].should == 'Wed, 7 Jan 2015 12:45:35'
    end
  end

  describe '#get_tags' do
    it 'should get tags' do
      @lastfm.should_receive(:request).with('album.getTags', {
        :artist => 'Cher',
        :album => 'Believe',
        :autocorrect => nil
      }, :get, true, true).and_return(make_response('album_get_tags'))

      tags = @lastfm.album.get_tags(
        :artist => 'Cher',
        :album => 'Believe')
      tags.size.should == 2
      tags[0]['name'].should == 'sourabh'
      tags[0]['url'].should == 'http://www.last.fm/tag/sourabh'
    end
  end

  describe '#get_top_tags' do
    it 'should get top tags' do
      @lastfm.should_receive(:request).with('album.getTopTags', {
        :artist => 'Radiohead',
        :album => 'The Bends',
        :autocorrect => nil
      }).and_return(make_response('album_get_top_tags'))

      tags = @lastfm.album.get_top_tags(
        :artist => 'Radiohead',
        :album => 'The Bends')
      tags.size.should == 2
      tags[0]['name'].should == 'albums I own'
      tags[0]['count'].should == '100'
      tags[0]['url'].should == 'http://www.last.fm/tag/albums%20i%20own'
    end
  end

  describe '#remove_tag' do
    it 'should remove tag' do
      @lastfm.should_receive(:request).with('album.removeTag', {
        :artist => 'foo artist',
        :album => 'foo track',
        :tag => 'aaa'
      }, :post, true, true).and_return(@ok_response)

      @lastfm.album.remove_tag(
        :artist => 'foo artist',
        :album => 'foo track',
        :tag => 'aaa').should be_true
    end
  end

  describe '#search' do
    it 'should search' do
      @lastfm.should_receive(:request).with('album.search', {
        :album => 'Believe',
        :limit => nil,
        :page => nil,
      }).and_return(make_response('album_search'))

      albums = @lastfm.album.search(:album => 'Believe')
      
      albums['results']['for'].should == 'Believe'
      albums['results']['totalResults'].should == '3926'
      albums['results']['albummatches']['album'].size.should == 2
      albums['results']['albummatches']['album'][0]['name'].should == 'Believe'
    end

    it 'should always return an array of albums' do
      @lastfm.should_receive(:request).with('album.search', {
        :album => 'Believe',
        :limit => nil,
        :page => nil,
      }).and_return(make_response('album_search_single_album'))

      albums = @lastfm.album.search(:album => 'Believe')
      
      albums['results']['for'].should == 'Believe'
      albums['results']['totalResults'].should == '3926'
      albums['results']['albummatches']['album'].size.should == 1
      albums['results']['albummatches']['album'][0]['name'].should == 'Believe'
    end
    
    it 'should return an empty array if no match found' do
      @lastfm.should_receive(:request).with('album.search', {
        :album => 'Believe',
        :limit => nil,
        :page => nil,
      }).and_return(make_response('album_search_no_match'))

      albums = @lastfm.album.search(:album => 'Believe')
      
      albums['results']['for'].should == 'Believe'
      albums['results']['totalResults'].should == '0'
      albums['results']['albummatches']['album'].size.should == 0
    end
  end

  describe '#share' do
    it 'should share' do
      @lastfm.should_receive(:request).with('album.share', {
        :artist => 'bar artist',
        :album => 'bar album',
        :recipient => 'bar@example.com',
        :message => 'this is a message',
        :public => nil,
      }, :post, true, true).and_return(@ok_response)

      @lastfm.album.share(
        :artist => 'bar artist',
        :album => 'bar album',
        :recipient => 'bar@example.com',
        :message => 'this is a message',
      ).should be_true
    end
  end
end
