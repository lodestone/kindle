require "active_record"
require_relative "kindle/settings"
require_relative "kindle/migrations/initializer"
require_relative "kindle/migrations/base_migration"
require_relative "kindle/models/highlight"
require_relative "kindle/models/book"
require_relative "kindle/parser/agent"
require_relative "kindle/parser/annotations"
require_relative "kindle/remote/book"
require_relative "kindle/remote/highlight"
require_relative "kindle/exports/markdown"
require_relative "kindle/exports/json"
require_relative "kindle/exports/csv"

# TODO: Handle multiple environments
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: Kindle::Settings::KINDLE_DATABASE_FILENAME)

module Kindle
  VERSION = "0.7.0.beta2"
  include Models
end
