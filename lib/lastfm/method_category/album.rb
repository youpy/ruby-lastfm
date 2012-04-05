class Lastfm
  module MethodCategory
    class Album < Base
      regular_method :get_info, [:artist, :album], [] do |response|
        result = response.xml['album']
        result['releasedate'].lstrip! unless result['releasedate'].empty?
        result
      end
    end
  end
end
