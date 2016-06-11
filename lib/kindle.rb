require 'dotenv'
require_relative 'kindle/cli'
require_relative 'kindle/config'
require_relative 'kindle/highlight'
require_relative 'kindle/highlights_parser'

module Kindle
  class Error < StandardError; end
  class Account
    attr_accessor :login, :password

    def initialize(login=nil, password=nil)
      @login = login || ENV['AMAZON_USERNAME']
      @password = password || ENV['AMAZON_PASSWORD']
    end

    def highlights
      @highlights = HighlightsParser.new(:login => @login, :password => @password).get_highlights
    end
  end
end
