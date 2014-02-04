require 'sinatra/base'
require 'openssl'
require 'json'
require 'cgi'

module Johannes

  class Application < Sinatra::Base

    set :cache_size, 512

    def self.base_uri=(base_uri)
      @base_uri = base_uri
    end

    def self.base_uri
      @base_uri
    end

    def self.secret=(secret)
      @secret = secret
    end

    def self.secret
      @secret
    end

    def self.require_signed_request?
      !! @secret
    end

    def self.generate_url_params(params)
      params['signature'] = signature(JSON.generate(params.to_a.sort))
      return params.map{|k,v| "#{k}=#{CGI.escape(v)}"}.join("&")
    end

    def self.path(params)
      '/?' + generate_url_params(params)
    end

    def self.dimensions_path(params)
      '/dimensions?' + generate_url_params(params)
    end

    def self.signature(payload)
      digest = OpenSSL::Digest::Digest.new("sha512")
      OpenSSL::HMAC.hexdigest(digest, self.secret, payload).to_s
    end

    def self.signature_matches?(actual_signature, payload)
      matched = true
      expected_signature = self.signature(payload)
      expected_signature.each_char.zip(actual_signature.to_s.each_char).each do |expected, actual|
        matched = false if expected != actual
      end

      matched
    end

    configure :production, :development do
      enable :logging
    end

    def create_image(signature, params)
      if image = Johannes::Cache.instance.get(signature)
        image
      else
        Johannes::Cache.instance.set signature, Johannes::Base.new(params).to_image
      end
    end

    def authenticate(request, &block)
      if Johannes::Application.require_signed_request?
        signature = request.params['signature']
        base_params = request.params
        base_params.delete('signature')
        payload   = JSON.generate(base_params.to_a.sort)

        if Johannes::Application.signature_matches?(signature, payload)
          block.call signature, base_params
        else
          status 403
        end
      else
        instance_eval &block
      end
    end

    get '/dimensions' do
      authenticate request do |signature, params|
        image = MiniMagick::Image.read(create_image(signature, params))
        JSON.generate({ width: image[:width], height: image[:height] })
      end
    end

    get '/' do
      authenticate request do |signature, params|
        content_type 'image/png'
        create_image(signature, params)
      end
    end

  end

end
