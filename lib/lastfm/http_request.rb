class HTTPRequest
  API_ROOT = 'http://ws.audioscrobbler.com/2.0'

  include HTTParty
  base_uri API_ROOT
  format :plain
end
