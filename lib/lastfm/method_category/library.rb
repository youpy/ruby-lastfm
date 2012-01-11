class Lastfm
  module MethodCategory
    class Library < Base
      regular_method :get_artists, [:user], [[:limit, nil], [:page, nil]] do |response|
        response.xml['artists']['artist']
      end
      
      regular_method :get_tracks, [:user], [[:artist, nil], [:album, nil], [:page, nil], [:limit, nil]]
        response.xml['tracks']['track']
      end
    end
  end
end
