class Lastfm
  module MethodCategory
    class User < Base
      regular_method :get_friends, [:user], [[:recenttracks, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['friends']['user']
      end

      regular_method :get_info, [:user], [] do |response|
        response.xml['user'][0]
      end

      regular_method :get_loved_tracks, [:user], [[:period, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['lovedtracks']['track']
      end

      regular_method :get_neighbours, [:user], [[:recenttracks, nil], [:limit, nil], [:page, nil]] do |response|
        neighbours = response.xml['neighbours']['user']
        # Ignore first "user" as this is an attribute, not an object.
        neighbours.delete_at(0) if neighbours[0].is_a? String
        neighbours
      end

      regular_method :get_personal_tags, [:user, :tag], [[:taggingtype, 'artist'], [:limit, nil], [:page, nil]] do |response|
        taggings = response.xml['taggings']
        result = if taggings['artists']
          taggings['artists']['artist']
        elsif taggings['albums']
          taggings['albums']['album']
        elsif taggings['tracks']
          taggings['tracks']['track']
        end

        Lastfm::Util::force_array(result)
      end

      method_with_authentication :get_recent_tracks, [:user], [[:limit, nil], [:page, nil], [:to, nil], [:from, nil]] do |response|
        response.xml['recenttracks']['track']
      end

      regular_method :get_top_albums, [:user], [[:period, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['topalbums']['album']
      end

      regular_method :get_top_artists, [:user], [[:period, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['topartists']['artist']
      end

      regular_method :get_top_tags, [:user], [[:limit, nil]] do |response|
        response.xml['toptags']['tag']
      end

      regular_method :get_top_tracks, [:user], [[:period, nil], [:limit, nil], [:page, nil]] do |response|
        response.xml['toptracks']['track']
      end

      regular_method :get_weekly_chart_list, [:user], [[:limit, nil]] do |response|
        response.xml['weeklychartlist']['chart']
      end

      regular_method :get_weekly_artist_chart, [:user], [[:from, nil], [:to, nil], [:limit, nil]] do |response|
        response.xml['weeklyartistchart']['artist']
      end

      regular_method :get_weekly_album_chart, [:user], [[:from, nil], [:to, nil], [:limit, nil]] do |response|
        response.xml['weeklyalbumchart']['album']
      end

      regular_method :get_weekly_track_chart, [:user], [[:from, nil], [:to, nil], [:limit, nil]] do |response|
        response.xml['weeklytrackchart']['track']
      end
    end
  end
end
