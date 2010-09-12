class Lastfm
  module MethodCategory
    class User < Base
      write_method :update_now_playing, [:artist, :track]
    end
  end
end
