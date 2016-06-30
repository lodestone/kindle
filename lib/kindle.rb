require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "#{ENV['HOME']}/.kindle/database.sqlite3")

require_relative 'kindle/cli'
require_relative 'kindle/settings'
require_relative "kindle/migrations/initializer"
require_relative "kindle/migrations/base_migration"
require_relative 'kindle/models/highlight'
require_relative 'kindle/models/book'
require_relative 'kindle/parser/agent'
require_relative 'kindle/parser/amazon'
require_relative 'kindle/remote/book'
require_relative 'kindle/remote/highlight'

module Kindle
  VERSION = "0.7.0"
  # def self.settings; @settings ||= Kindle::Settings.new; end

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
