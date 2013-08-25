class Lastfm
  module MethodCategory
    class User < Base
      regular_method(
        :get_friends,
        :required => [:user],
        :optional => [
          [:recenttracks, nil],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['friends']['user']
      end

      def get_info(*args)
        method = :get_info.to_s.camelize(:lower)
        response = if args.any?
          options = Lastfm::Util.build_options(args, [:user], [])
          request(method, options)
        else
          request_with_authentication(method)
        end
        response.xml['user'][0]
      end

      regular_method(
        :get_loved_tracks,
        :required => [:user],
        :optional => [
          [:period, nil],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['lovedtracks']['track']
      end

      regular_method(
        :get_neighbours,
        :required => [:user],
        :optional => [
          [:recenttracks, nil],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        neighbours = response.xml['neighbours']['user']
        # Ignore first "user" as this is an attribute, not an object.
        neighbours.delete_at(0) if neighbours[0].is_a? String
        neighbours
      end

      regular_method(
        :get_new_releases,
        :required => [:user],
        :optional => [
          [:userecs, nil],
        ]
      ) do |response|
        response.xml['albums']['album']
      end

      regular_method(
        :get_personal_tags,
        :required => [:user, :tag],
        :optional => [
          [:taggingtype, 'artist'],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
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

      regular_method(
        :get_recent_tracks,
        :required => [:user],
        :optional => [
          [:limit, nil],
          [:page, nil],
          [:to, nil],
          [:from, nil]
        ]
      ) do |response|
        response.xml['recenttracks']['track']
      end

      regular_method(
        :get_top_albums,
        :required => [:user],
        :optional => [
          [:period, nil],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['topalbums']['album']
      end

      regular_method(
        :get_top_artists,
        :required => [:user],
        :optional => [
          [:period, nil],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['topartists']['artist']
      end

      regular_method(
        :get_top_tags,
        :required => [:user],
        :optional => [[:limit, nil]]
      ) do |response|
        response.xml['toptags']['tag']
      end

      regular_method(
        :get_top_tracks,
        :required => [:user],
        :optional => [
          [:period, nil],
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        response.xml['toptracks']['track']
      end

      regular_method(
        :get_weekly_chart_list,
        :required => [:user],
        :optional => [
          [:limit, nil]
        ]
      ) do |response|
        response.xml['weeklychartlist']['chart']
      end

      regular_method(
        :get_weekly_artist_chart,
        :required => [:user],
        :optional => [
          [:from, nil],
          [:to, nil],
          [:limit, nil]
        ]
      ) do |response|
        response.xml['weeklyartistchart']['artist']
      end

      regular_method(
        :get_weekly_album_chart,
        :required => [:user],
        :optional => [
          [:from, nil],
          [:to, nil],
          [:limit, nil]
        ]
      ) do |response|
        response.xml['weeklyalbumchart']['album']
      end

      regular_method(
        :get_weekly_track_chart,
        :required => [:user],
        :optional => [
          [:from, nil],
          [:to, nil],
          [:limit, nil]
        ]
      ) do |response|
        response.xml['weeklytrackchart']['track']
      end

      method_with_authentication(
        :get_recommended_events
      ) do |response|
        response.xml['events']['event']
      end

      method_with_authentication(
        :get_recommended_artists
      ) do |response|
        response.xml['recommendations']['artist']
      end
    end
  end
end
