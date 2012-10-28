class Lastfm
  module MethodCategory
    class Tasteometer < Base
      regular_method :compare, [:type1, :type2, :value1, :value2], [[:limit, nil]] do |response|
        response.xml['comparison']['result']
      end
    end
  end
end
