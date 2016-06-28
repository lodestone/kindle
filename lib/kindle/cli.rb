require_relative '../kindle'
require "kindle"
require 'methadone'

module Kindle
  class CLI

    include Methadone::Main
    include Methadone::CLILogging

    main do |command, format|
      case command
      when "init"
        require "kindle/initializer"
        Kindle::Initializer.new
      when "highlights"
        # TODO: Highlights
      when "update"
        # TODO: update highlights
      when "console"
        require 'pry'
        # Start interactive session
        Pry.config.requires = ["kindle/highlight", "kindle/book"]
        Pry.start self, prompt: [proc { "Kindle :) " }]
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

    on("console") do
      # IRB.start
    end

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
