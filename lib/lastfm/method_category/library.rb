class Lastfm
  module MethodCategory
    class Library < Base
      regular_method :get_artists, [:user], [[:limit, nil], [:page, nil]] do |response|
        response.xml['artists']['artist']
      end
    end
  end
end
