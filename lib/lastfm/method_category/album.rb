class Lastfm
  module MethodCategory
    class Album < Base
      regular_method(
        :get_info,
        :required => any_params([:artist, :album], :mbid)
      ) do |response|
        result = response.xml['album']

        result['releasedate'].lstrip! unless result['releasedate'].empty?
        result
      end
    end
  end
end
