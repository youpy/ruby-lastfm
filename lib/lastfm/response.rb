require 'rubygems'
require 'json'

class Lastfm
  class Response
    def initialize(body)
      # API returns XML response when no child node?
      if body == '<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
</lfm>
'
        @parsed_body = {}
      else
        @parsed_body = JSON.parse(body)
      end
    end

    def [](key)
      @parsed_body[key]
    end

    def success?
      !self['error']
    end

    def message
      self['message']
    end

    def error
      self['error']
    end
  end
end
