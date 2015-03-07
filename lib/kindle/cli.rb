require 'thor'
require 'highline/import'

module Kindle
  class CLI < Thor
    desc "highlights", "Display Kindle Highlights"
    def highlights
      puts ">> Kindle Highlights Fetcher::::::::::::::::::::::::::::::::::::::::"
      kindle = Kindle::Account.new
      login = kindle.settings.username

      if login
        puts "Using Amazon username: #{login}"
      else
        ask("Enter your Amazon username:  ") { |q| q.echo = true } unless login = argv[0]
      end
      passwd = ask("Enter your Amazon password (This is not stored):  ") { |q| q.echo = "•" }

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
    # > kindle help
    # > kindle highlights -t json
    # > kindle highlights --type=json
    # > kindle documents -t pretty --only="/Book Title Regex/"
    # > kindle highlights -t json
    # > kindle highlights -t json
  end
end
