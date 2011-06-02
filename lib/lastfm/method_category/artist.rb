class Lastfm
  module MethodCategory
    class Artist < Base
      regular_method :get_events, [:artist], [] do |response|
        response.xml['events']['event']
      end

      regular_method :search, [:artist], [[:limit, nil], [:page, nil]]
    end
  end
end
