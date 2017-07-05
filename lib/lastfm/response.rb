require 'rubygems'
require 'xmlsimple'

class Lastfm
  class Response
    attr_reader :xml

    def initialize(body)
      # workaround for https://github.com/youpy/ruby-lastfm/issues/83
      body = fix_body(body)

      @xml = XmlSimple.xml_in(body, 'ForceArray' => ['image', 'tag', 'user', 'event', 'correction'])
    rescue REXML::ParseException
      @xml = XmlSimple.xml_in(body.encode(Encoding.find("ISO-8859-1"), :undef => :replace),
                              'ForceArray' => ['image', 'tag', 'user', 'event', 'correction'])
    end

    def success?
      @xml['status'] == 'ok'
    end

    def message
      @xml['error']['content']
    end

    def error
      @xml['error']['code'].to_i
    end

    private

    def fix_body(body)
      namespace_attr = 'xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"'

      body.sub(/(<results[^>]*)/) do |str|
        if str.match(namespace_attr)
          str
        else
          '%s %s' % [str, namespace_attr]
        end
      end
    end
  end
end
