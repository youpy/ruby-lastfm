class Lastfm
  module MethodCategory
    class Auth < Base
      method_for_authentication :get_token do |response|
        response.xml['token']
      end

      method_for_authentication(
        :get_session,
        :required => [:token]
      ) do |response|
        response.xml['session']
      end

      method_for_secure_authentication(
        :get_mobile_session,
        :required => [:username, :password]
      ) do |response|
        response.xml['session']
      end
    end
  end
end
