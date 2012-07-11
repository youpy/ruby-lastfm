class Lastfm
  class Util
    def self.force_array(array_or_something)
      array_or_something.kind_of?(Array) ? array_or_something : [array_or_something]
    end

    def self.build_options(args, mandatory, optional)
      options = {}

      if args.first.is_a?(Hash)
        # mandatory parameter check
        mandatory.each do |name|
          raise ArgumentError.new("#{name} is required") unless args.first.has_key?(name)
        end
        options = args.first
      else
        mandatory.each_with_index do |name, index|
          raise ArgumentError.new('%s is required' % name) unless args[index]
          options[name] = args[index]
        end

        optional.each_with_index do |name, index|
          value = name[1]
          if value.kind_of?(Proc)
            value = value.call
          end
          options[name[0]] = args[index + mandatory.size] || value
        end
      end

      options
    end
  end
end
