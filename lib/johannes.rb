require "johannes/version"

require 'johannes/base'
require 'johannes/application'

module Johannes
end

Johannes::Application.secret = ENV['JOHANNES_SECRET']
