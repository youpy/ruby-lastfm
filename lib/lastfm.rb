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
require 'lastfm/method_category/album'
require 'lastfm/method_category/user'
require 'lastfm/method_category/geo'
require 'lastfm/method_category/library'

class Lastfm
  API_ROOT = 'http://ws.audioscrobbler.com/2.0'

  include HTTParty
  base_uri API_ROOT

  attr_accessor :session

  class Error < StandardError; end
  class ApiError < Error
    attr_reader :code

    def initialize(message, code = nil)
      super(message)
      @code = code
    end
  end

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
  
  def album
    MethodCategory::Album.new(self)
  end

  def user
    MethodCategory::User.new(self)
  end

  def geo
    MethodCategory::Geo.new(self)
  end

  def library
    MethodCategory::Library.new(self)
  end

  def request(method, params = {}, http_method = :get, with_signature = false, with_session = false)
    params[:method] = method
    params[:api_key] = @api_key

    params.each do |k, v|
      if v.nil?
        params.delete(k)
      end
    end

    # http://www.lastfm.jp/group/Last.fm+Web+Services/forum/21604/_/497978
    #params[:format] = format

    params.update(:sk => @session) if with_session
    params.update(:api_sig => Digest::MD5.hexdigest(build_method_signature(params))) if with_signature

    response = Response.new(self.class.send(http_method, '/', (http_method == :post ? :body : :query) => params).body)
    unless response.success?
      raise ApiError.new(response.message, response.error)
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
