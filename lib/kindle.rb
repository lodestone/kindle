require 'nokogiri'
require 'mechanize'
require_relative 'kindle/highlight'
require_relative 'kindle/reader'

module Kindle

  class Kindle

    include Nokogiri
    
    def initialize(options = {})
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) }
    end

    def get_kindle_highlights
      reader = Reader.new(login: @login, password: @password)
      reader.get_kindle_highlights
    end

  end

end
