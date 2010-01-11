class Lastfm
  class Auth < MethodCategory
    def get_token
      request_for_authentication('getToken')['token']
    end

    def get_session(token)
      request_for_authentication('getSession', { :token => token })['session']['key']
    end
  end
end
