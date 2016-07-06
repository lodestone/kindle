module Kindle
  class Settings

    KINDLE_SETTINGS_DIRECTORY = "#{ENV["HOME"]}/.kindle"
    KINDLE_SETTINGS_FILENAME  = "#{KINDLE_SETTINGS_DIRECTORY}/kindlerc.yml"
    KINDLE_DATABASE_FILENAME  = "#{KINDLE_SETTINGS_DIRECTORY}/kindle.db"

    attr_reader :settings

    def initialize
      create_default_settings_directory unless Dir.exists?(KINDLE_SETTINGS_DIRECTORY)
      if  File.exists?(KINDLE_SETTINGS_FILENAME)
        @settings = YAML.load(File.open(KINDLE_SETTINGS_FILENAME).read) || {}
        settings.each do |name, value|
          set_variable(name.to_s, value)
        end
      else
        @settings = {}
      end
    end

    def url
      if domain.blank?
        raise "Please set :domain: in your settings file!"
      else
        "https://kindle.#{domain}"
      end
    end

    private

    def create_default_settings_directory
      Dir.mkdir KINDLE_SETTINGS_DIRECTORY
    end

    # def create_default_kindle_settings
    #   `touch #{KINDLE_SETTINGS_FILENAME}`
    # end

    # def create_default_database_settings
    #   File.open(KINDLE_DATABASE_FILENAME, "w") {|f| f << default_database_settings }
    # end
    #
    # def default_database_settings
    #   <<~EOF
    #   production:
    #     adapter: sqlite3
    #     database: ~/.kindle/kindle.db
    #
    #   development:
    #     adapter: sqlite3
    #     database: ~/.kindle/database-dev.sqlite
    #
    #   test:
    #     adapter: sqlite3
    #     database: ~/.kindle/database-test.sqlite
    #   EOF
    # end

    def set_variable(name, value)
      instance_variable_set("@#{name}", value)
      self.class.class_eval { attr_accessor name.intern }
    end

  end
end
