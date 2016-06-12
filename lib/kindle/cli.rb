require 'thor'
require 'highline/import'

module Kindle
  class CLI < Thor
    desc "highlights", "Display Kindle Highlights"
    def highlights
      say ">> Kindle Highlights Fetcher::::::::::::::::::::::::::::::::::::::::", :yellow
      say "   This will access your Amazon Kindle highlights on the web.       \n", :white
      say "   We need to have your Amazon credentials in order to get them.    \n", :white
      say "   We don't store this anywhere! (^c to cancel)                     \n", :white
      say ">> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n", :yellow
      kindle = Kindle::Account.new
      # login = ENV['AMAZON_USERNAME'] if ENV['AMAZON_USERNAME']

      # if login
        # say "Using Amazon username: #{login}"
      # else
      login = ask("Enter your Amazon username:  ", {echo: true})
      # end
      passwd = ask("Enter your Amazon password (This is not stored): ", {echo: false})

      begin
        kindle.login = login
        kindle.password = passwd
        puts "Getting your kindle highlights..."
        kindle.highlights.each do |highlight|
          puts "#{highlight.asin};#{highlight.title};#{highlight.author};#{highlight.highlight}"
        end
      rescue => ex
        # TODO Actually handle this!
        puts ex
        puts "Crud, something went wrong..."
      end
    end

    # Usage:
    # TODO: Pass in something to bide our time
    # TODO: Multiple output formats. CSV, JSON, Pretty, HTML?
    # TODO: Cache results, add --force flag
    # kindle hl --help
    # kindle highlights --force --to pretty
    # kindle highlights --force --to json
    # kindle highlights --force --to html
    # kindle highlights --force --to markdown
    # kindle highlights --force --to plain
    # kindle highlights --force --to csv
    # > kindle help
    # > kindle highlights -t json
    # > kindle highlights --type=json
    # > kindle documents -t pretty --only="/Book Title Regex/"
    # > kindle highlights -t json
    # > kindle highlights -t json
  end
end
