class Lastfm
  module MethodCategory
    class Artist < Base
      regular_method :get_events, [:artist], [:mbid, :autocorrect, :limit, :page, :festivalsonly] do |response|
        response.xml['events']['event']
      end

      regular_method :get_top_tags, [:artist], [:mbid, :autocorrect] do |response|
        response.xml['toptags']['tag']
      end

      regular_method :get_top_albums, [:artist], [:mbid, :autocorrect, :page, :limit] do |response|
        response.xml['topalbums']['album']
      end

      regular_method :get_images, [:artist], [:page, :limit, :autocorrect, :order] do |response|
        response.xml['images']['image']
      end

      regular_method :search, [:artist], [:limit, :page]
    end
  end
end
