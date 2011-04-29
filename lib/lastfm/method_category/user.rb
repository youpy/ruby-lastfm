class Lastfm
  module MethodCategory
    class User < Base
      regular_method :get_info, [:user], [] do |response|
        response.xml['user'][0]
      end

      regular_method :get_friends, [:user], [[:recenttracks, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['friends']['user']
      end
      
      regular_method :get_neighbours, [:user], [[:recenttracks, nil], [:limit, nil], [:page, nil]] do |response|
        neighbours = response.xml['neighbours']['user']
        #ignore first "user" as this is an attribute, not an object
        neighbours.delete_at(0) if neighbours[0].is_a? String
        neighbours
      end

      regular_method :get_recent_tracks, [:user], [[:limit, nil], [:page, nil], [:to, nil], [:from, nil]] do |response|
        response.xml['recenttracks']['track']
      end
    end
  end
end
