class Lastfm
  class Track < MethodCategory
    def love(artist, track)
      request('love', {
          :artist => artist,
          :track => track,
          :sk => @lastfm.session
        }, :post)
    end
  end
end
