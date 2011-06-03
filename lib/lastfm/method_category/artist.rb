class Lastfm
  module MethodCategory
    class Artist < Base
      regular_method :get_events, [:artist], [] do |response|
        response.xml['events']['event']
      end

      regular_method :get_top_tags, [:artist], [] do |response|
        response.xml['toptags']['tag']
      end

      regular_method :get_top_albums, [:artist, :limit], [] do |response|
        response.xml['topalbums']['album']
      end

      regular_method :get_images, [:artist, :limit, :order], [] do |response|
        response.xml['images']['image']
      end

      regular_method :search, [:artist], [[:limit, nil], [:page, nil]]
    end
  end
end
