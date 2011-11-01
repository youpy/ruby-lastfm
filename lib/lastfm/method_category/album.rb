class Lastfm
  module MethodCategory
    class Album < Base
      regular_method :get_info, [:artist, :album], [] do |response|
        response.xml['album']
      end
    end
  end
end
