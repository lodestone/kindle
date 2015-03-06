require 'dotenv'

module Kindle
  #   class Config
  #
  #     def initialize
  #       Dotenv.load
  #     end
  #
  #   end
  #
  # end
  #
  module Settings
    # we don't want to instantiate this class - it's a singleton,
    # so just keep it as a self-extended module
    extend self

    def method_missing(method_name, *args)
      nil
    end

    # Appdata provides a basic single-method DSL with .parameter method
    # being used to define a set of available settings.
    # This method takes one or more symbols, with each one being
    # a name of the configuration option.
    def parameter(*names)
      names.each do |name|
        attr_accessor name

        # For each given symbol we generate accessor method that sets option's
        # value being called with an argument, or returns option's current value
        # when called without arguments
        define_method name do |*values|
          value = values.first
          value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
        end
      end
    end

    # Dotenv
    def load_settings_from_dotenv
      Dotenv.load
      ENV.each do |k,v|
        if k =~ /^AMAZON_/
          method = k.downcase.gsub("amazon_", "").to_sym
          parameter(method)
          send(method, v)
        end
        # puts [k,v].inspect if k =~ /^AMAZON/
      end
    end

    def load_settings_file(settings_file)
      load_settings_from_dotenv
      # TODO YAML
      # load_settings_from_yaml
      # TODO JSON
      # load_settings_from_json
      # TODO Ruby
      # load_settings_from_ruby
    end

    # And we define a wrapper for the configuration block, that we'll use to set up
    # our set of options
    def config(settings_file=nil)
      load_settings_file(settings_file)
      instance_eval &block if block_given?
    end

  end

end
# Janked from: http://speakmy.name/2011/05/29/simple-configuration-for-ruby-apps/
