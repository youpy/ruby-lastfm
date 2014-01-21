class Lastfm
  module MethodCategory
    class Artist < Base
      regular_method(
        :get_top_tracks,
        :required => [:artist]
      ) do |response|
        response.xml['toptracks']['track']
      end

      regular_method(
        :get_top_albums,
        :required => [:artist]
      ) do |response|
        response.xml['topalbums']['album']
      end

      regular_method(
        :get_info,
        :required => [:artist]
      ) do |response|
        response.xml['artist']
      end

      regular_method(
        :get_events,
        :required => [:artist]
      ) do |response|
        response.xml['events']['event']
      end

      regular_method(
        :get_images,
        :required => [:artist]
      ) do |response|
        response.xml['images']['image']
      end

      regular_method(:get_similar,
        :required => [:artist]
      ) do |response|
        response.xml['similarartists']['artist']
      end

      regular_method(
        :get_tags,
        :required => [:artist],
        :optional => [
          [:user, nil],
          [:mbid, nil],
          [:autocorrect, nil]
        ]
      ) do |response|
        response.xml['tags']['tag']
      end

      regular_method(
        :get_top_fans,
        :required => [:artist]
      ) do |response|
        response.xml['topfans']['user']
      end

      regular_method(
        :get_top_tags,
        :required => any_params([:artist], [:mbid]),
        :optional => [
          [:autocorrect, nil]
        ]
      ) do |response|
        response.xml['toptags']['tag']
      end

      regular_method(
        :search,
        :required => [:artist],
        :optional => [
          [:limit, nil],
          [:page, nil]
        ]
      )
    end
  end
end
