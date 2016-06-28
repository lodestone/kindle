require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "#{ENV['HOME']}/.kindle/database.sqlite3")

require_relative 'kindle/account'
require_relative 'kindle/agent'
require_relative 'kindle/book'
require_relative 'kindle/cli'
require_relative 'kindle/settings'
require_relative 'kindle/highlight'
require_relative 'kindle/highlights_parser'
require_relative "kindle/version"
require_relative "kindle/initializer"
require_relative "kindle/migrate/base_migration"

module Kindle

  def self.settings; @settings ||= Kindle::Settings.new; end

  # def self.init(options={})
  #   puts "init"
  #   # ActiveRecord::Base.configurations = YAML::load(IO.read(ENV['HOME']+'/.kindle/database.yml'))
  #   # ActiveRecord::Base.establish_connection("development")
  #   CreateBaseStructure.migrate(:up)
  #   Kindle.settings.username = options[:username] if options[:username]
  #   Kindle.settings.password = options[:password] if options[:password]
  #   self
  # end

  # def self.highlights
  #   @highlights ||= HighlightsParser.new.highlights
  # end

end
