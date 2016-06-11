require 'dotenv'
require_relative 'kindle/cli'
require_relative 'kindle/config'
require_relative 'kindle/highlight'
require_relative 'kindle/highlights_parser'

Dotenv.load

module Kindle

  class Error < StandardError; end

  class Account

    attr_accessor :login, :password

    def initialize(login=nil, password=nil)
      @login = login || ENV['AMAZON_USERNAME']
      @password = password || ENV['AMAZON_PASSWORD']
    end

    def highlights
      @highlights = Highlights.new(:login => @login, :password => @password).fetch_highlights
    end

  end

  class Highlights

    def initialize(options = {})
      options.each { |k,v| instance_variable_set("@#{k}", v) }
    end

    def fetch_highlights
      HighlightsParser.new(login: @login, password: @password).get_highlights
    end

  end

end
