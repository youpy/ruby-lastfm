class Lastfm
  module MethodCategory
    class Event < Base
      regular_method :get_info, [:event_id], [] do |response|
        response.xml['event'].first
      end
    end
  end
end
