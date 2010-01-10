class Lastfm
  class MethodCategory
    def initialize(lastfm)
      @lastfm = lastfm
    end

    def request(*args)
      method, *rest = args
      method = [self.class.name.split(/::/).last.downcase, method].join('.')

      @lastfm.request(method, *rest)
    end
  end
end
