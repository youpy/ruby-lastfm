class Lastfm
  module MethodCategory
    class Auth < Base
      method_for_authentication :get_token, [], [] do |response|
        response.xml['token']
      end

      method_for_authentication :get_session, [:token], [] do |response|
        response.xml['session']['key']
      end
    end
  end
end
