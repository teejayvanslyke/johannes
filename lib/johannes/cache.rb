require 'rufus-lru'
require 'singleton'

module Johannes

  class Cache

    include Singleton

    def initialize
      @data = Rufus::Lru::Hash.new(512)
    end

    def set(key, value)
      @data[key] = value
    end

    def get(key)
      @data[key]
    end

  end

end
