require_relative '../kindle'
require 'methadone'
require "pry"
$:.push File.expand_path(__FILE__)

module Kindle
  class CLI

    include Methadone::Main
    include Methadone::CLILogging

    description "Fetch and query your Amazon Kindle Highlights"
    defaults_from_config_file ENV["HOME"] + "/.kindle/settings.yml"
    
    main do |command, format|
      case command
      when "init"
        require_relative "migrations/initializer"
        Kindle::Migrations::Initializer.new
      when "highlights"
        puts format
        # TODO
      when "update"
        require "kindle/settings"
        require "kindle/parser/annotations"
        Kindle::Parser::Annotations.new
      when "console"
        # Pry.config.requires = [
        #   "kindle/models/highlight",
        #   "kindle/models/book",
        #   "kindle/settings",
        #   "kindle/parser/annotations"
        # ]
        Pry.start Kindle, prompt: [proc { "Kindle :) " }]
      when "help"
        # TODO: Help
      else
        # TODO: Display help
      end
    end

    arg :command
    arg :format, :optional

    #
    # on("highlights") do
    #   if Kindle.settings.credentials?
    #     # We have credentials in our settings file
    #     kindle = Kindle.new(
    #       username: Kindle.settings.username,
    #       password: Kindle.settings.password
    #     )
    #   else
    #     # We need to prompt for credentials
    #     say ">> Kindle Highlights Fetcher::::::::::::::::::::::::::::::::::::::::", :yellow
    #     say "   This will access your Amazon Kindle highlights on the web.       \n", :white
    #     say "   We need to have your Amazon credentials in order to get them.    \n", :white
    #     say "   We don't store this anywhere! (^c to cancel)                     \n", :white
    #     say ">> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n", :yellow
    #     username = ask("Enter your Amazon username:  ", {echo: true})
    #     password = ask("Enter your Amazon password (This is not stored): ", {echo: false})
    #     kindle = Kindle.init(username: username, password: password)
    #   end
    #   kindle.highlights
    # end

    # on("console") do
      # IRB.start
    # end
    version(Kindle::VERSION)
    go!
  end
end

#     class App
#
#       main do |needed, maybe|
#         options[:switch] => true or false, based on command line
#         options[:flag] => value of flag passed on command line
#       end
#
#       # Proxy to an OptionParser instance's on method
#       on("--[no]-switch")
#       on("--flag VALUE")
#
#       arg :needed
#       arg :maybe, :optional
#
#       defaults_from_env_var SOME_VAR
#       defaults_from_config_file '.my_app.rc'
#
#       go!
#     end
