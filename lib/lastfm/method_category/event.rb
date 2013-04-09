class Lastfm
  module MethodCategory
    class Event < Base
      regular_method(
        :get_info,
        :required => [:event]
      ) do |response|
        response.xml['event'].first
      end
    end
  end
end
