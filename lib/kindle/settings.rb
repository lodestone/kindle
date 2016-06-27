module Kindle
  class Settings

    KINDLE_SETTINGS_DIRECTORY = "#{ENV["HOME"]}/.kindle/"
    KINDLE_SETTINGS_FILENAME = "#{KINDLE_SETTINGS_DIRECTORY}/settings.json"

    def url
      "https://kindle.#{Kindle.settings.domain}"
    end

    def initialize
      # Check settings directory
      if !Dir.exists?(KINDLE_SETTINGS_DIRECTORY)
        Dir.mkdir(KINDLE_SETTINGS_DIRECTORY)
      end

      # Check the kindle settings file exists, create it if needed
      if File.exists?(KINDLE_SETTINGS_FILENAME)
        settings = JSON.load(File.open(KINDLE_SETTINGS_FILENAME))
        if settings
          settings.each do |name, value|
            set_variable(name, value)
          end
        end
      else
        File.open(KINDLE_SETTINGS_FILENAME, "w") {|f| f << default_settings_json }
      end
    end

    def credentials?
      Kindle.settings.username && Kindle.settings.password
    end

    private

    def default_settings_json
<<-JSON
{
  "domain": "amazon.com"
}
JSON
    end

    def set_variable(name, value)
      instance_variable_set("@#{name}", ENV[name.upcase] || value)
      self.class.class_eval { attr_accessor name.intern }
    end

  end
end
