module Kindle
  class Settings

    KINDLE_SETTINGS_DIRECTORY = "#{ENV["HOME"]}/.kindle/"
    KINDLE_SETTINGS_FILENAME = "#{KINDLE_SETTINGS_DIRECTORY}/settings.yml"
    KINDLE_DATABASE_FILENAME = "#{KINDLE_SETTINGS_DIRECTORY}/database.yml"

    def initialize
      create_default_settings_directory unless Dir.exists?(KINDLE_SETTINGS_DIRECTORY)
      create_default_file unless File.exists?(KINDLE_SETTINGS_FILENAME)
      settings.each do |name, value|
        set_variable(name, value)
      end
    end

    def url
      "https://kindle.#{domain}" rescue "Please set \"domain\" in your settings file!"
    end

    private
    
    def settings
      @settings ||= (YAML.load(File.open(KINDLE_SETTINGS_FILENAME))||{})
    end

    def create_default_settings_directory
      Dir.mkdir KINDLE_SETTINGS_DIRECTORY
    end

    def create_default_files
      create_default_settings_files
      create_default_database_settings
    end

    def create_default_settings_files
      File.open(KINDLE_SETTINGS_FILENAME, "w") {|f| f << default_configuration_settings }
    end

    def create_default_database_settings
      File.open(KINDLE_SETTINGS_FILENAME, "w") {|f| f << default_database_settings }
    end

    def default_configuration_settings
      File.open("templates/settings.yml").read
    end

    def default_database_settings
      File.open("templates/database.yml").read
    end

    def set_variable(name, value)
      instance_variable_set("@#{name}", ENV[name.upcase] || value)
      self.class.class_eval { attr_accessor name.intern }
    end

  end
end
