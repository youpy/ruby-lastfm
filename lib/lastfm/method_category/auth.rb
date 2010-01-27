class Lastfm
  module MethodCategory
    class Auth < Base
      def get_token
        response = request_for_authentication('getToken')
        response.xml.xpath('/lfm/token').first.content
      end

      def get_session(token)
        response = request_for_authentication('getSession', { :token => token })
        response.xml.xpath('/lfm/session/key').first.content
      end
    end
  end
end
