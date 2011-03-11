require 'rubygems'
require 'digest/md5'
require 'httparty'
require 'active_support/core_ext/string/inflections'

require 'lastfm/util'
require 'lastfm/response'
require 'lastfm/method_category/base'
require 'lastfm/method_category/auth'
require 'lastfm/method_category/track'
require 'lastfm/method_category/artist'
require 'lastfm/method_category/user'

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
    MethodCategory::Auth.new(self)
  end

  def track
    MethodCategory::Track.new(self)
  end

  def artist
    MethodCategory::Artist.new(self)
  end

  def user
    MethodCategory::User.new(self)
  end

  def request(method, params = {}, http_method = :get, with_signature = false, with_session = false)
    params[:method] = method
    params[:api_key] = @api_key

    # http://www.lastfm.jp/group/Last.fm+Web+Services/forum/21604/_/497978
    #params[:format] = format

    params.update(:sk => @session) if with_session
    params.update(:api_sig => Digest::MD5.hexdigest(build_method_signature(params))) if with_signature

    response = Response.new(self.class.send(http_method, '/', (http_method == :post ? :body : :query) => params).body)
    unless response.success?
      raise ApiError.new(response.message)
    end

    response
  end

  private

  def build_method_signature(params)
    params.to_a.sort_by do |param|
      param.first.to_s
    end.inject('') do |result, param|
      result + param.join('')
    end + @api_secret
  end
end
