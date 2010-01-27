require 'rubygems'
require 'nokogiri'

class Lastfm
  class Response
    attr_reader :xml

    def initialize(body)
      @xml = Nokogiri::XML.parse(body)
    end

    def success?
      @xml.root['status'] == 'ok'
    end

    def message
      @xml.xpath('/lfm/error').first.content
    end

    def error
      @xml.xpath('/lfm/error').first['code'].to_i
    end
  end
end
