require 'sinatra/base'

module Johannes

  class Application < Sinatra::Base

    configure :production, :development do
      enable :logging
    end

    get '/' do
      content_type 'image/png'
      Johannes::Base.new(params).to_image
    end

  end

end
