require 'lastfm/response'
require 'lastfm/method_category'

require 'lastfm/method_category/auth'
require 'lastfm/method_category/track'

require 'rubygems'
require 'digest/md5'
require 'httparty'

class Lastfm
  API_ROOT = 'http://ws.audioscrobbler.com/2.0'

  include HTTParty
  base_uri API_ROOT

  attr_accessor :session

  class Error < StandardError; end
  class ApiError < Error; end

  def initialize(api_key, api_secret)
    @api_key = api_key
    @api_secret = api_secret
  end

  def auth
    Auth.new(self)
  end

  def track
    Track.new(self)
  end

  def request(method, params = {}, http_method = :get)
    params[:method] = method
    params[:api_key] = @api_key

    # http://www.lastfm.jp/group/Last.fm+Web+Services/forum/21604/_/497978
    #params[:format] = format

    sig = params.to_a.sort_by do |param|
      param.first.to_s
    end.inject('') do |result, param|
      result + param.join('')
    end + @api_secret

    params.update(:api_sig => Digest::MD5.hexdigest(sig), :format => 'json')
    response = Response.new(self.class.send(http_method, '/', (http_method == :post ? :body : :query) => params).body)

    unless response.success?
      raise ApiError.new(response.message)
    end

    response
  end
end
