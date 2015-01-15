class Lastfm
  module MethodCategory
    class Group < Base
      regular_method(
        :get_members,
        :required => [:group],
        :optional => [
          [:limit, nil],
          [:page, nil]
        ]
      ) do |response|
        Util.force_array(response.xml['members']['user'])
      end
    end
  end
end
