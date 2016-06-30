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

      highlights.desc "Refresh the database of highlights"
      highlights.long_desc "Scrape your current Kindle highlights and update the local database"
      highlights.command :update do |update|
        update.action do
          puts "TODO: UPDATING"
        end
      end

      highlights.desc "Export highlights and books as JSON"
      highlights.command :json do |json|
        json.action do
          puts Kindle::Exports::Json.new(Kindle::Models::Highlight.includes(:book).all)
        end
      end

      highlights.desc "Export highlights and books as CSV"
      highlights.command :csv do |csv|
        csv.action do
          puts Kindle::Exports::Csv.new(Kindle::Models::Highlight.includes(:book).all)
        end
      end

      highlights.desc "Export highlights and books as Markdown"
      highlights.command :markdown do |markdown|
        markdown.action do
          puts Kindle::Exports::Markdown.new(Kindle::Models::Book.order("title ASC").all)
        end
      end
    end

    exit run(ARGV)

  end
end
