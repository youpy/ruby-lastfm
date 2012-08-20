class Lastfm
  module MethodCategory
    class Artist < Base
      regular_method :get_top_tracks, [:artist], [] do |response|
        response.xml['toptracks']['track']
      end

      regular_method :get_top_albums, [:artist], [] do |response|
        response.xml['topalbums']['album']
      end
      
      regular_method :get_info, [:artist], [] do |response|
        response.xml['artist']
      end

      regular_method :get_events, [:artist], [] do |response|
        response.xml['events']['event']
      end

      regular_method :get_similar, [:artist], [] do |response|
        response.xml['similarartists']['artist']
      end
      
      regular_method :get_tags, [:artist], [[:user, nil], [:mbid, nil], [:autocorrect, nil]] do |response|
        response.xml['tags']['tag']
      end

      regular_method :search, [:artist], [[:limit, nil], [:page, nil]]
    end
  end
end
