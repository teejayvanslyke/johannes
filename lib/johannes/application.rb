require 'sinatra/base'
require 'openssl'
require 'json'

module Johannes

  class Application < Sinatra::Base

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

    def self.path(params)
      params['signature'] = signature(:get, '/', JSON.generate(params.to_a.sort))
      return '/?' + URI.encode(params.map{|k,v| "#{k}=#{v}"}.join("&"))
    end

    def self.signature(method, path, payload)
      message = [method, path, payload].map(&:to_s).inject(&:+)

      digest = OpenSSL::Digest::Digest.new("sha512")
      OpenSSL::HMAC.hexdigest(digest, self.secret, message).to_s
    end

    def self.signature_matches?(actual_signature, method, path, payload)
      matched = true
      expected_signature = self.signature(method, path, payload)
      expected_signature.each_char.zip(actual_signature.to_s.each_char).each do |expected, actual|
        matched = false if expected != actual
      end

      matched
    end

    configure :production, :development do
      enable :logging
    end

    get '/' do

      if Johannes::Application.require_signed_request?
        signature = params['signature']
        method    = request.request_method.downcase
        path      = request.path
        base_params = params
        base_params.delete('signature')
        payload   = JSON.generate(base_params.to_a.sort)

        if Johannes::Application.signature_matches?(signature, method, path, payload)
          content_type 'image/png'
          Johannes::Base.new(params).to_image
        else
          status 403
        end
      else
        content_type 'image/png'
        Johannes::Base.new(params).to_image
      end
    end

  end

end
