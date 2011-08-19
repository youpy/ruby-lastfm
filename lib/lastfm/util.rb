class Lastfm
  class Util
    def self.build_options(args, mandatory, optional)
      options = {}

      args << {} if args.empty?
      raise "Must provide arguments as hash" unless args.first && args.first.is_a?(Hash)
      args_hash = args.first

      mandatory.each do |name|
        raise ArgumentError.new("#{name} is required") unless args_hash.has_key?(name)
        options[name] = args_hash[name]
      end

      optional.each do |field|
        options[field.first] = args_hash[field.first] || field.last
      end

      options
    end
  end
end
