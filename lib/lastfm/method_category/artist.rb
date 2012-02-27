class Lastfm
  module MethodCategory
    class Artist < Base
      regular_method :get_info, [:artist], [] do |response|
        response.xml['artist']
      end
      regular_method :get_events, [:artist], [] do |response|
        response.xml['events']['event']
      end      
      regular_method :get_similar, [:artist], [] do |response|
        response.xml['similarartists']['artist'].select{|o|o.is_a? Hash}
      end
    end
  end
end
