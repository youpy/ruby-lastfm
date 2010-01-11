class Lastfm
  class Track < MethodCategory
    def love(artist, track)
      request_with_authentication('love', {
          :artist => artist,
          :track => track,
        })
    end
  end
end
