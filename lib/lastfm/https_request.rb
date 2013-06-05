class HTTPSRequest
  HTTPS_API_ROOT = 'https://ws.audioscrobbler.com/2.0'

  include HTTParty
  base_uri HTTPS_API_ROOT
  format :plain
end
