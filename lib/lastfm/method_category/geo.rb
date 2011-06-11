class Lastfm
  module MethodCategory
    class Geo < Base
      regular_method :get_events, [], [[:location, nil], [:distance, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['events']['event']
      end
    end
  end
end
