class Lastfm
  module MethodCategory
    class Track < Base
      write_method :add_tags, [:artist, :track, :tags]
      write_method :remove_tag, [:artist, :track, :tag]
      write_method :ban, [:artist, :track]
      write_method :love, [:artist, :track]
      write_method :share, [:artist, :track, :recipient], [[:message, nil]]
      write_method :scrobble, [:artist, :track], [[:timestamp, Proc.new { Time.now.utc.to_i }], [:album, nil], [:trackNumber, nil], [:mbid, nil], [:duration, nil], [:albumArtist, nil]]
      write_method :update_now_playing, [:artist, :track], [[:album, nil], [:trackNumber, nil], [:mbid, nil], [:duration, nil], [:albumArtist, nil]]
      write_method :unlove, [:artist, :track]

      regular_method :get_info, [:artist, :track], [[:username, nil]] do |response|
        response.xml['track']
      end

      regular_method :get_correction, [:artist, :track], [] do |response|
        response.xml['corrections']['correction']
      end

      regular_method :get_top_fans, [:artist, :track], [] do |response|
        response.xml['topfans']['user']
      end
      regular_method :get_top_tags, [:artist, :track], [] do |response|
        response.xml['toptags']['tag']
      end
      regular_method :get_similar, [:artist, :track], [] do |response|
        response.xml['similartracks']['track'][1 .. -1]
      end
      regular_method :search, [:track], [[:artist, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['results']['trackmatches']['track'] = Util.force_array(response.xml['results']['trackmatches']['track'])
        response.xml
      end

      method_with_authentication :get_tags, [:artist, :track], [] do |response|
        response.xml['tags']['tag']
      end
    end
  end
end
