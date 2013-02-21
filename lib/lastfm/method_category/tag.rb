class Lastfm
  module MethodCategory
    class Tag < Base
      regular_method :get_top_artists, [:tag], [[:limit, nil], [:page, nil]] do |response|
        response.xml['topartists']['artist']
      end

      regular_method :get_top_tracks, [:tag], [[:limit, nil], [:page, nil]] do |response|
        response.xml['toptracks']['track']
      end
    end
  end
end
