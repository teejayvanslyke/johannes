require "johannes/version"
require 'johannes/base'
require 'johannes/cache'
require 'johannes/application'

require 'open-uri'

module Johannes
  def self.url_for(params)
    URI.join(Johannes::Application.base_uri, Johannes::Application.path(params)).to_s
  end

  def self.dimensions_of(params)
    json = open(URI.join(Johannes::Application.base_uri, Johannes::Application.dimensions_path(params)).to_s).read
    JSON.parse(json)
  end
end

Johannes::Application.base_uri = ENV['JOHANNES_BASE_URI']
Johannes::Application.secret = ENV['JOHANNES_SECRET'] || 'omgwtfbbq'
Johannes::Base.stylesheets = JSON.parse(ENV['JOHANNES_STYLESHEETS'] || '[]')

if ENV['JOHANNES_HEROKU']
  IMGKit.configure do |config|
    config.wkhtmltoimage = File.dirname(__FILE__) + '/../vendor/bin/wkhtmltoimage-amd64'
  end
end

