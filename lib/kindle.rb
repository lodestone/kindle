require "active_record"

require_relative 'kindle/account'
require_relative 'kindle/agent'
require_relative 'kindle/book'
require_relative 'kindle/cli'
require_relative 'kindle/settings'
require_relative 'kindle/highlight'
require_relative 'kindle/highlights_parser'
require_relative "kindle/version"

module Kindle

  def self.settings; @settings ||= Settings.new; end

  def init(options={})
    Kindle.settings.username = options[:username] if options[:username]
    Kindle.settings.password = options[:password] if options[:password]
    self
  end

  def highlights
    @highlights ||= HighlightsParser.new.highlights
  end

end
