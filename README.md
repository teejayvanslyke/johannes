# Johannes

Simple text-to-image generation daemon in Ruby, powered by Sinatra.

## Installation

Make sure you have wkhtmltoimage installed. You'll want to configure IMGKit to point 
at it:

    IMGKit.configure do |config|
      config.wkhtmltoimage = '/path/to/wkhtmltoimage'
    end

Add this line to your application's Gemfile:

    gem 'johannes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install johannes

## Usage

TODO

