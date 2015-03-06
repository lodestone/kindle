require_relative 'kindle/cli'
require_relative 'kindle/config'
require_relative 'kindle/highlight'
require_relative 'kindle/highlights_parser'

module Kindle

  class Account

    attr_accessor :login, :password

    def initialize(login=nil, password=nil)
      @login = login || Kindle::Settings.username
      @password = password || Kindle::Settings.password
    end

    def settings
      Kindle::Settings.config
      return Kindle::Settings
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
