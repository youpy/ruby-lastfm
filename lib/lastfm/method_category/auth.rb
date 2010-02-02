class Lastfm
  module MethodCategory
    class Auth < Base
      def get_token
        request_for_authentication('getToken').xml['token']
      end

      def get_session(token)
        request_for_authentication('getSession', { :token => token }).
          xml['session']['key']
      end
    end
  end
end
