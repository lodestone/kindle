class Kindle

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
          settings.each { |name, value|
            set_variable(name, value)
          }
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
      if value.is_a? Hash
        value.each do |key, value|
          set_config_variable("#{name}_#{key}", value)
        end
      end
      puts "=== Setting #{name} to #{value}"
      instance_variable_set("@#{name}", ENV[name.upcase] || value)
      self.class.class_eval { attr_reader name.intern }
    end

    def method_missing(method, *args)
    end

  end
end
