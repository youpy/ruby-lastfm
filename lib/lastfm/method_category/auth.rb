class Lastfm
  class Auth < MethodCategory
    def get_token
      request('getToken')['token']
    end

    def get_session(token)
      request('getSession', { :token => token })['session']['key']
    end
  end
end
