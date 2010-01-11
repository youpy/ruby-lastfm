class Lastfm
  class MethodCategory
    def initialize(lastfm)
      @lastfm = lastfm
    end

    def request_with_authentication(method, params = {})
      request(method, params, :post, true, true)
    end

    def request_for_authentication(method, params = {})
      request(method, params, :get, true)
    end

    def request(*args)
      method, *rest = args
      method = [self.class.name.split(/::/).last.downcase, method].join('.')

      @lastfm.request(method, *rest)
    end
  end
end
