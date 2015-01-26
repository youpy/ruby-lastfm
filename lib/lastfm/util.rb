class Lastfm
  class Util
    def self.force_array(array_or_something)
      array_or_something.kind_of?(Array) ? array_or_something : [array_or_something].compact
    end

    def self.build_options(args, mandatory, optional)
      if args.first.is_a?(Hash)
        build_options_from_hash(args.first, mandatory || [], optional || [])
      else
        build_options_from_array(args, mandatory || [], optional || [])
      end
    end

    def self.build_options_from_hash(options, mandatory, optional)
      candidates = mandatory.kind_of?(AnyParams) ? mandatory.candidates : [mandatory]
      candidates.each do |params|
        missing_param = Array(params).any? { |param| !options.key?(param) }
        if missing_param && params.equal?(candidates.last)
          raise ArgumentError.new("%s is required" % candidates.map{ |c| Array(c).join(', ')}.join(' or '))
        end

        break unless missing_param
      end

      optional.each do |name, value|
        options[name] ||= value.kind_of?(Proc) ? value.call : value
      end

      options
    end

    def self.build_options_from_array(values, mandatory, optional)
      options = {}

      mandatory.each_with_index do |name, index|
        raise ArgumentError.new('%s is required' % name) unless values[index]
        options[name] = values[index]
      end

      optional.each_with_index do |name, index|
        value = name[1]
        if value.kind_of?(Proc)
          value = value.call
        end
        options[name[0]] = values[index + mandatory.size] || value
      end

      options
    end
  end
end
