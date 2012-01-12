class Lastfm
  module MethodCategory
    class Library < Base
      regular_method :get_artists, [:user], [[:limit, nil], [:page, nil]] do |response|
        Util.force_array(response.xml['artists']['artist'])
      end

      regular_method :get_tracks, [:user], [[:artist, nil], [:album, nil], [:page, nil], [:limit, nil]] do |response|
        Util.force_array(response.xml['tracks']['track'])
      end
    end
  end
end
