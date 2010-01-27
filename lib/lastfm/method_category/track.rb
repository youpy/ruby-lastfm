class Lastfm
  module MethodCategory
    class Track < Base
      def add_tags(artist, track, tags)
        write_request('addTags', {
            :artist => artist,
            :track => track,
            :tags => tags
          }).success?
      end

      def ban(artist, track)
        write_request('ban', {
            :artist => artist,
            :track => track,
          }).success?
      end

      def get_info(artist, track, username = nil)
        Scrobbler::Track.new_from_xml(request('getInfo', {
              :artist => artist,
              :track => track,
              :username => username
            }).xml)
      end

      def get_similar(artist, track)
        response = request('getSimilar', {
            :artist => artist,
            :track => track,
          })

        response.xml.xpath('/lfm/similartracks/track').map do |track|
          Scrobbler::Track.new_from_xml(track)
        end
      end

      def get_tags(artist, track)
        request_with_authentication('getTags', {
            :artist => artist,
            :track => track,
          })
      end

      def get_top_fans(artist, track)
        request('getTopFans', {
            :artist => artist,
            :track => track,
          })
      end

      def get_top_tags(artist, track)
        request('getTopTags', {
            :artist => artist,
            :track => track,
          })
      end

      def love(artist, track)
        write_request('love', {
            :artist => artist,
            :track => track,
          }).success?
      end

      def remove_tag(artist, track, tag)
        write_request('removeTag', {
            :artist => artist,
            :track => track,
            :tag => tag
          }).success?
      end

      def search(artist, track, limit = nil, page = nil)
        request('search', {
            :artist => artist,
            :track => track,
            :limit => limit,
            :page => page
          })
      end

      def share(artist, track, recipient, message = nil)
        write_request('share', {
            :artist => artist,
            :track => track,
            :recipient => recipient,
            :message => message
          }).success?
      end
    end
  end
end
