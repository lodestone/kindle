module Kindle
  class Settings

    KINDLE_SETTINGS_DIRECTORY = "#{ENV["HOME"]}/.kindle"
    KINDLE_SETTINGS_FILENAME  = "#{KINDLE_SETTINGS_DIRECTORY}/kindlerc.yml"
    KINDLE_DATABASE_FILENAME  = "#{KINDLE_SETTINGS_DIRECTORY}/database.yml"

    attr_reader :settings

    def initialize
      create_default_settings_directory unless Dir.exists?(KINDLE_SETTINGS_DIRECTORY)
      create_default_files unless File.exists?(KINDLE_SETTINGS_FILENAME)
      @settings = YAML.load(File.open(KINDLE_SETTINGS_FILENAME).read) || {}
      settings.each do |name, value|
        set_variable(name.to_s, value)
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

    def create_default_files
      create_default_database_settings
    end

    def create_default_database_settings
      File.open(KINDLE_SETTINGS_FILENAME, "w") {|f| f << default_database_settings }
    end

    def default_database_settings
      File.open("templates/database.yml").read
    end

    def set_variable(name, value)
      instance_variable_set("@#{name}", value)
      self.class.class_eval { attr_accessor name.intern }
    end

  end
end
