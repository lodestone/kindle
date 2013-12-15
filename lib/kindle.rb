require 'nokogiri'
require 'mechanize'
require_relative 'kindle/highlight'
require_relative 'kindle/reader'

module Kindle

  class Kindle
    include Nokogiri
    
    KINDLE_URL = 'http://kindle.amazon.com'

    attr_reader :agent, :current_page, :asins, :highlights

    def initialize(options = {:login => nil, :password => nil})
      @highlights = [] 
      @current_offset = 25
      @current_highlights = 1
      @current_upcoming = []
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) }
      @agent = Mechanize.new
      @agent.redirect_ok = true
      @agent.user_agent_alias = 'Windows IE 7'
    end

    def get_kindle_highlights
      reader = Reader.new(login: @login, password: @password)
      reader.get_kindle_highlights
    end

  end


end
