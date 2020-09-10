# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe '#album' do
  before { init_lastfm }

  it 'should return an instance of Lastfm::Album' do
    expect(@lastfm.album).to be_an_instance_of(Lastfm::MethodCategory::Album)
  end

  describe '#add_tags' do
    it 'should add tags' do
      expect(@lastfm).to receive(:request).with('album.addTags', {
        :artist => 'foo artist',
        :album => 'foo track',
        :tags => 'aaa,bbb,ccc'
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.album.add_tags(
        :artist => 'foo artist',
        :album => 'foo track',
        :tags => 'aaa,bbb,ccc'
        )).to be_truthy
    end
  end

  describe '#get_buylinks' do
    it 'should get buylinks' do
      expect(@lastfm).to receive(:request).with('album.getBuylinks', {
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

      expect(buylinks['physicals'].size).to eq(1)
      expect(buylinks['physicals']['affiliation']['supplierName']).to eq('Amazon')
      expect(buylinks['physicals']['affiliation']['price']['currency']).to eq('GBP')
      expect(buylinks['physicals']['affiliation']['price']['amount']).to eq('6.34')
      expect(buylinks['physicals']['affiliation']['price']['formatted']).to eq('£6.34')
      expect(buylinks['physicals']['affiliation']['buyLink']).to eq('http://www.last.fm/affiliate/byid/8/3418994/1/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc')

      expect(buylinks['downloads'].size).to eq(1)
      expect(buylinks['downloads']['affiliation']['supplierName']).to eq('Amazon MP3')
      expect(buylinks['downloads']['affiliation']['price']['currency']).to eq('GBP')
      expect(buylinks['downloads']['affiliation']['price']['amount']).to eq('7.99')
      expect(buylinks['downloads']['affiliation']['price']['formatted']).to eq('£7.99')
      expect(buylinks['downloads']['affiliation']['buyLink']).to eq('http://www.last.fm/affiliate/byid/8/3418994/44/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc')
    end
    
    it 'should get buylinks by mbid' do
      expect(@lastfm).to receive(:request).with('album.getBuylinks', {
        :mbid => 'radiohead',
        :country => 'united kingdom',
        :autocorrect => nil
      }).and_return(make_response('album_get_buylinks'))

      buylinks = @lastfm.album.get_buylinks(
        :mbid => 'radiohead',
        :country => 'united kingdom'
      )

      expect(buylinks['physicals'].size).to eq(1)
      expect(buylinks['physicals']['affiliation']['supplierName']).to eq('Amazon')
      expect(buylinks['physicals']['affiliation']['price']['currency']).to eq('GBP')
      expect(buylinks['physicals']['affiliation']['price']['amount']).to eq('6.34')
      expect(buylinks['physicals']['affiliation']['price']['formatted']).to eq('£6.34')
      expect(buylinks['physicals']['affiliation']['buyLink']).to eq('http://www.last.fm/affiliate/byid/8/3418994/1/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc')

      expect(buylinks['downloads'].size).to eq(1)
      expect(buylinks['downloads']['affiliation']['supplierName']).to eq('Amazon MP3')
      expect(buylinks['downloads']['affiliation']['price']['currency']).to eq('GBP')
      expect(buylinks['downloads']['affiliation']['price']['amount']).to eq('7.99')
      expect(buylinks['downloads']['affiliation']['price']['formatted']).to eq('£7.99')
      expect(buylinks['downloads']['affiliation']['buyLink']).to eq('http://www.last.fm/affiliate/byid/8/3418994/44/ws.album.buylinks.f4e2585261d8d10d3297e181d68940fc')
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
      expect(@lastfm).to receive(:request).with('album.getInfo', {
        :artist => 'Cher', :album => 'Believe'
      }).and_return(make_response('album_get_info'))

      album = @lastfm.album.get_info(:artist => 'Cher', :album => 'Believe')
      expect(album['name']).to eq('Believe')
      expect(album['artist']).to eq('Cher')
      expect(album['id']).to eq('2026126')
      expect(album['mbid']).to eq('61bf0388-b8a9-48f4-81d1-7eb02706dfb0')
      expect(album['url']).to eq('http://www.last.fm/music/Cher/Believe')
      expect(album['image'].size).to eq(5)
      expect(album['releasedate']).to eq('6 Apr 1999, 00:00')
      expect(album['tracks']['track'].size).to eq(10)
      expect(album['tracks']['track'][0]['name']).to eq('Believe')
      expect(album['tracks']['track'][0]['duration']).to eq('239')
      expect(album['tracks']['track'][0]['url']).to eq('http://www.last.fm/music/Cher/_/Believe')
    end

    it 'should get info by mbid' do
      expect(@lastfm).to receive(:request).with('album.getInfo', {
        :mbid => 'xxxxx'
      }).and_return(make_response('album_get_info'))

      album = @lastfm.album.get_info(:mbid => 'xxxxx')
      expect(album['name']).to eq('Believe')
      expect(album['artist']).to eq('Cher')
      expect(album['id']).to eq('2026126')
      expect(album['mbid']).to eq('61bf0388-b8a9-48f4-81d1-7eb02706dfb0')
      expect(album['url']).to eq('http://www.last.fm/music/Cher/Believe')
      expect(album['image'].size).to eq(5)
      expect(album['releasedate']).to eq('6 Apr 1999, 00:00')
      expect(album['tracks']['track'].size).to eq(10)
      expect(album['tracks']['track'][0]['name']).to eq('Believe')
      expect(album['tracks']['track'][0]['duration']).to eq('239')
      expect(album['tracks']['track'][0]['url']).to eq('http://www.last.fm/music/Cher/_/Believe')
    end
    
    it 'works without release date' do
      expect(@lastfm).to receive(:request).with('album.getInfo', {
        :mbid => 'xxxxx'
      }).and_return(make_response('album_get_info_without_release_date'))

      album = @lastfm.album.get_info(:mbid => 'xxxxx')
      expect(album['name']).to eq('Believe')
    end
  end

  describe '#get_shouts' do
    it 'should get shouts' do
      expect(@lastfm).to receive(:request).with('album.getShouts', {
        :artist => 'Cher',
        :album => 'Believe',
        :autocorrect => nil,
        :limit => nil,
        :page => nil
      }).and_return(make_response('album_get_shouts'))

      shouts = @lastfm.album.get_shouts(
        :artist => 'Cher',
        :album => 'Believe')
      expect(shouts.size).to eq(2)
      expect(shouts[0]['body']).to eq('A perfect Pop/Dance Masterpiece')
      expect(shouts[0]['author']).to eq('top20fanatico')
      expect(shouts[0]['date']).to eq('Wed, 7 Jan 2015 12:45:35')
    end
  end

  describe '#get_tags' do
    it 'should get tags' do
      expect(@lastfm).to receive(:request).with('album.getTags', {
        :artist => 'Cher',
        :album => 'Believe',
        :autocorrect => nil
      }, :get, true, true).and_return(make_response('album_get_tags'))

      tags = @lastfm.album.get_tags(
        :artist => 'Cher',
        :album => 'Believe')
      expect(tags.size).to eq(2)
      expect(tags[0]['name']).to eq('sourabh')
      expect(tags[0]['url']).to eq('http://www.last.fm/tag/sourabh')
    end
  end

  describe '#get_top_tags' do
    it 'should get top tags' do
      expect(@lastfm).to receive(:request).with('album.getTopTags', {
        :artist => 'Radiohead',
        :album => 'The Bends',
        :autocorrect => nil
      }).and_return(make_response('album_get_top_tags'))

      tags = @lastfm.album.get_top_tags(
        :artist => 'Radiohead',
        :album => 'The Bends')
      expect(tags.size).to eq(2)
      expect(tags[0]['name']).to eq('albums I own')
      expect(tags[0]['count']).to eq('100')
      expect(tags[0]['url']).to eq('http://www.last.fm/tag/albums%20i%20own')
    end
  end

  describe '#remove_tag' do
    it 'should remove tag' do
      expect(@lastfm).to receive(:request).with('album.removeTag', {
        :artist => 'foo artist',
        :album => 'foo track',
        :tag => 'aaa'
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.album.remove_tag(
        :artist => 'foo artist',
        :album => 'foo track',
        :tag => 'aaa')).to be_truthy
    end
  end

  describe '#search' do
    it 'should search' do
      expect(@lastfm).to receive(:request).with('album.search', {
        :album => 'Believe',
        :limit => nil,
        :page => nil,
      }).and_return(make_response('album_search'))

      albums = @lastfm.album.search(:album => 'Believe')
      
      expect(albums['results']['for']).to eq('Believe')
      expect(albums['results']['totalResults']).to eq('3926')
      expect(albums['results']['albummatches']['album'].size).to eq(2)
      expect(albums['results']['albummatches']['album'][0]['name']).to eq('Believe')
    end

    it 'should always return an array of albums' do
      expect(@lastfm).to receive(:request).with('album.search', {
        :album => 'Believe',
        :limit => nil,
        :page => nil,
      }).and_return(make_response('album_search_single_album'))

      albums = @lastfm.album.search(:album => 'Believe')
      
      expect(albums['results']['for']).to eq('Believe')
      expect(albums['results']['totalResults']).to eq('3926')
      expect(albums['results']['albummatches']['album'].size).to eq(1)
      expect(albums['results']['albummatches']['album'][0]['name']).to eq('Believe')
    end
    
    it 'should return an empty array if no match found' do
      expect(@lastfm).to receive(:request).with('album.search', {
        :album => 'Believe',
        :limit => nil,
        :page => nil,
      }).and_return(make_response('album_search_no_match'))

      albums = @lastfm.album.search(:album => 'Believe')
      
      expect(albums['results']['for']).to eq('Believe')
      expect(albums['results']['totalResults']).to eq('0')
      expect(albums['results']['albummatches']['album'].size).to eq(0)
    end
  end

  describe '#share' do
    it 'should share' do
      expect(@lastfm).to receive(:request).with('album.share', {
        :artist => 'bar artist',
        :album => 'bar album',
        :recipient => 'bar@example.com',
        :message => 'this is a message',
        :public => nil,
      }, :post, true, true).and_return(@ok_response)

      expect(@lastfm.album.share(
        :artist => 'bar artist',
        :album => 'bar album',
        :recipient => 'bar@example.com',
        :message => 'this is a message',
      )).to be_truthy
    end
  end
end
