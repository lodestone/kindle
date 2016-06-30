require_relative "../kindle"
require "pry"
require "gli"
require "rainbow"

$:.push File.expand_path(__FILE__)

module Kindle
  class CLI

    extend GLI::App

    config_file ".kindle/kindlerc.yml"

    program_desc Rainbow("Fetch and query your Amazon Kindle Highlights").cyan
    version Kindle::VERSION

    flag [:u, :username]
    flag [:p, :password]
    flag [:d, :domain], default_value: "amazon.com"

    desc "Open an interactive console"
    long_desc %{
      Open an interactive console with both Book and Highlight objects available.
    }
    command :console do |c|
      c.action do |global_options,options,args|
        Pry.start Kindle, prompt: [proc { "Kindle :) " }]
      end
    end

    desc "Alias for initdb followed by initconfig commands"
    long_desc %{
      Creates the ~/.kindle/kindle.db SQLITE file
      Creates the ~/.kindle directory and a default config file
    }
    command :init do |c|
      c.action do |global_options, options, args|
        commands[:initdb].execute(global_options, options, args)
        commands[:initconfig].execute(global_options, options, args)
      end
    end

    desc "Initialize the highlights database"
    long_desc %{
      Creates a SQLITE3 database to store/cache your highlights
    }
    command :initdb do |c|
      c.action do |global_options, options, args|
        begin
          puts Rainbow("\nInitializing the database...").green
          Kindle::Migrations::Initializer.new
        rescue ActiveRecord::StatementInvalid
          puts Rainbow("Looks like the database is already created, skipping...").red
        end
      end
    end

    desc "Export Highlights"
    long_desc %{
      Output your highlights in JSON, CSV, or Markdown format
    }
    command :highlights do |highlights|
      highlights.command :json do |json|
        json.action do
          puts Kindle::Exports::Json.new(Kindle::Models::Highlight.includes(:book).all)
        end
      end
      highlights.command :csv do |csv|
        csv.action do
          puts Kindle::Exports::Csv.new(Kindle::Models::Highlight.includes(:book).all)
        end
      end
      highlights.command :markdown do |markdown|
        markdown.action do
          puts Kindle::Exports::Markdown.new(Kindle::Models::Book.order("title ASC").all)
        end
      end
    end
    # main do |command, format|
    #   case command
    #   when "init"
    #     require_relative "migrations/initializer"
    #     Kindle::Migrations::Initializer.new
    #   when "highlights"
    #     puts format
    #     # TODO
    #   when "update"
    #     require "kindle/settings"
    #     require "kindle/parser/annotations"
    #     Kindle::Parser::Annotations.new
    #   when "console"
    #     # Pry.config.requires = [
    #     #   "kindle/models/highlight",
    #     #   "kindle/models/book",
    #     #   "kindle/settings",
    #     #   "kindle/parser/annotations"
    #     # ]
    #     Pry.start Kindle, prompt: [proc { "Kindle :) " }]
    #   when "help"
    #     # TODO: Help
    #   else
    #     # TODO: Display help
    #   end
    # end
    #
    # arg :command
    # arg :format, :optional

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
    # version(Kindle::VERSION)
    # go!
    exit run(ARGV)
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
