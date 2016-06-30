require_relative "../kindle"
require_relative "migrations/base_migration"

module Kindle
  module Migrations
    class Initializer
      def initialize
        # ActiveRecord::Base.configurations = YAML::load(IO.read(ENV['HOME']+'/.kindle/database.yml'))
        # ActiveRecord::Base.establish_connection("development")
        CreateBaseStructure.migrate(:up)
      end
    end
  end
end
