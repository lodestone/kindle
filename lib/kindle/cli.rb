require_relative "../kindle"
require "pry"
require "gli"
require "rainbow"

module Kindle
  class CLI
    extend GLI::App

    sort_help :manually
    config_file ".kindle/kindlerc.yml"
    program_desc Rainbow("Fetch and query your Amazon Kindle Highlights").cyan
    version Kindle::VERSION

    hide_commands_without_desc true

    flag [:username, :u]
    flag [:password, :p]
    flag [:domain,   :d], default_value: "amazon.com"

    # NOTE: Commenting out these descriptions to *hide* the option from help
    # desc "Initialize the highlights database"
    # long_desc "Creates a SQLITE3 database to store/cache your highlights"
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

    desc Rainbow("Initialize the database and config files").yellow
    long_desc <<~EOD
      Creates the ~/.kindle/kindle.db SQLITE file
      Creates the ~/.kindle directory and a default config file
    EOD
    command :init do |c|
      c.action do |global_options, options, args|
        commands[:initdb].execute(global_options, options, args)
        commands[:initconfig].execute(global_options, options, args)
      end
    end

    desc Rainbow("Export Highlights as JSON, CSV, or Markdown").yellow
    long_desc "Output your highlights database in JSON, CSV, or Markdown format"
    command :highlights do |highlights|

      highlights.desc Rainbow("Refresh the database of highlights").yellow
      highlights.long_desc "Scrape your current Kindle highlights and update the local database"
      highlights.command :update do |update|
        update.action do
          Kindle::Parser::Annotations.new
        end
      end

      highlights.desc Rainbow("Export highlights and books as JSON").yellow
      highlights.command :json do |json|
        json.action do
          puts Kindle::Exports::Json.new(Kindle::Models::Highlight.includes(:book).all)
        end
      end

      highlights.desc Rainbow("Export highlights and books as CSV").yellow
      highlights.command :csv do |csv|
        csv.action do
          puts Kindle::Exports::Csv.new(Kindle::Models::Highlight.includes(:book).all)
        end
      end

      highlights.desc Rainbow("Export highlights and books as Markdown").yellow
      highlights.command :markdown do |markdown|
        markdown.action do
          puts Kindle::Exports::Markdown.new(Kindle::Models::Book.order("title ASC").all)
        end
      end
    end

    desc Rainbow("Open an interactive console").yellow
    long_desc %{
      Open an interactive console with both Book and Highlight objects available.
    }
    command :console do |c|
      c.action do |global_options,options,args|
        Pry.start Kindle, prompt: [proc { "Kindle :) " }]
      end
    end

    # NOTE: Fuckery to hide the auto generated actions:
    helpcmd = commands[:help]
    helpcmd.instance_variable_set("@description", Rainbow(helpcmd.instance_variable_get("@description")).yellow)
    commands[:initconfig].instance_variable_set("@description", nil)
    commands[:initconfig].instance_variable_set("@hide_commands_without_desc", true)

    exit run(ARGV)

  end
end
