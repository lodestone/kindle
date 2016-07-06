require_relative "base_migration"

module Kindle
  module Migrations
    class Initializer
      def initialize
        CreateBaseStructure.migrate(:up)
      end
    end
  end
end
