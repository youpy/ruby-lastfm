require 'rubygems'
require 'xmlsimple'

class Lastfm
  class Response
    attr_reader :xml

    def initialize(body)
      @xml = XmlSimple.xml_in(body, 'ForceArray' => ['image', 'tag', 'user', 'event', 'correction'])
    rescue REXML::ParseException
      @xml = XmlSimple.xml_in(body.encode(Encoding.find("ISO-8859-1"), :undef => :replace), 'ForceArray' => ['image', 'tag', 'user', 'event', 'correction'])
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
  end
end
