class Lastfm
  module MethodCategory
    class Track < Base
      write_method :add_tags, [:artist, :track, :tags]
      write_method :remove_tag, [:artist, :track, :tag]
      write_method :ban, [:artist, :track]
      write_method :love, [:artist, :track]
      write_method :share, [:artist, :track, :recipient], [[:message, nil]]

      regular_method :get_info, [:artist, :track], [[:username, nil]] do |response|
        response.xml['track']
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
      regular_method :search, [:track], [[:artist, nil], [:limit, nil], [:page, nil]]

      method_with_authentication :get_tags, [:artist, :track], [] do |response|
        response.xml['tag']
      end
    end
  end
end
