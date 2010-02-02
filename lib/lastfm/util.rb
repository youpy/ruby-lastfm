class Lastfm
  class Util
    def self.build_options(args, mandatory, optional)
      options = {}

      mandatory.each_with_index do |name, index|
        raise ArgumentError.new('%s is required' % name) unless args[index]
        options[name] = args[index]
      end

      optional.each_with_index do |name, index|
        options[name[0]] = args[index + mandatory.size] || name[1]
      end

      options
    end
  end
end
