class Lastfm
  module MethodCategory
    class Tag < Base
      regular_method(
        :get_top_artists,
        :required => [:tag],
        :optional => [
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['topartists']['artist']
      end

      regular_method(
        :get_top_tracks,
        :required => [:tag],
        :optional => [
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['toptracks']['track']
      end

      regular_method(
        :get_top_albums,
        :required => [:tag],
        :optional => [
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['topalbums']['album']

      end
      
      regular_method(
        :search,
        :required => [:tag],
        :optional => [
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['results']['tagmatches']['tag']
      end

      regular_method(
        :get_info,
        :required => [:tag]
      ) do |response|
        response.xml['tag']
      end
    end
  end
end
