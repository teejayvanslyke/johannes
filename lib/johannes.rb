require "johannes/version"
require 'johannes/base'
require 'johannes/application'

module Johannes
end

Johannes::Application.secret = ENV['JOHANNES_SECRET'] || 'omgwtfbbq'
Johannes::Base.stylesheets = JSON.parse(ENV['JOHANNES_STYLESHEETS'] || '[]')

if ENV['JOHANNES_HEROKU']
  IMGKit.configure do |config|
    config.wkhtmltoimage = File.dirname(__FILE__) + '/../vendor/bin/wkhtmltoimage-amd64'
  end
end

