class Lastfm
  module MethodCategory
    class Chart < Base
      regular_method :get_hyped_artists, [], [[:page, nil], [:limit, nil]] do |response|
        response.xml['artists']['artist']
      end
      
      regular_method :get_hyped_tracks, [], [[:page, nil], [:limit, nil]] do |response|
        response.xml['tracks']['track']
      end
      
      regular_method :get_loved_tracks, [], [[:page, nil], [:limit, nil]] do |response|
        response.xml['tracks']['track']
      end
      
      regular_method :get_top_artists, [], [[:page, nil], [:limit, nil]] do |response|
        response.xml['artists']['artist']
      end
      
      regular_method :get_top_tags, [], [[:page, nil], [:limit, nil]] do |response|
        response.xml['tags']['tag']
      end
      
      regular_method :get_top_tracks, [], [[:page, nil], [:limit, nil]] do |response|
        response.xml['tracks']['track']
      end
    end
  end
end
