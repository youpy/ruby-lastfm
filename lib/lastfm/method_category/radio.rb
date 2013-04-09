class Lastfm
  module MethodCategory
    class Radio < Base
      write_method :tune, :required => [:station]
      method_with_authentication :get_playlist do |response|
        playlist = response.xml['playlist']
        tracklist = playlist['trackList']['track']

        unless tracklist.is_a?(Array)
          playlist['trackList']['track'] = [tracklist]
        end

        playlist
      end
    end
  end
end
