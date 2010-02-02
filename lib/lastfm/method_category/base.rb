class Lastfm
  module MethodCategory
    class Base
      class << self
        def write_method(id, mandatory, optional = [])
          __define_method(:write_request, id, mandatory, optional) do |response|
            response.success?
          end
        end

        def method_with_authentication(id, mandatory, optional = [], &block)
          __define_method(:request_with_authentication, id, mandatory, optional, &block)
        end

        def method_for_authentication(id, mandatory, optional = [], &block)
          __define_method(:request_for_authentication, id, mandatory, optional, &block)
        end

        def regular_method(id, mandatory, optional = [], &block)
          __define_method(:request, id, mandatory, optional, &block)
        end

        def __define_method(method, id, mandatory, optional, &block)
          unless block
            block = Proc.new { |response| response.xml }
          end

          define_method(id) do |*args|
            block.call(send(method, id.to_s.camelize(:lower), Lastfm::Util.build_options(args, mandatory, optional)))
          end
        end
      end

      def initialize(lastfm)
        @lastfm = lastfm
      end

      def write_request(method, params = {})
        request(method, params, :post, true, true)
      end

      def request_with_authentication(method, params = {})
        request(method, params, :get, true, true)
      end

      def request_for_authentication(method, params = {})
        request(method, params, :get, true)
      end

      def request(*args)
        method, *rest = args
        method = [self.class.name.split(/::/).last.downcase, method].join('.')

        @lastfm.request(method, *rest)
      end
    end
  end
end
