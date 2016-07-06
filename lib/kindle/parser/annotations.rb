require "mechanize"
require "nokogiri"
require "json"
require_relative "agent"
require_relative "../remote/highlight"
require_relative "../remote/book"
require_relative "../models/highlight"
require_relative "../models/book"

module Kindle
  module Parser
    class Annotations

      SETTINGS = Kindle::Settings.new

      attr_accessor :page, :highlights
      attr_reader :books

      def initialize(options={})
        @username   = SETTINGS.username || options[:username]
        @password   = SETTINGS.password || options[:password]
        @books      = []
        @highlights = []
        load_highlights
      end

      def load_highlights
        # Log in to kindle.amazon.TLD
        login
        # Collect the list of books that have highlighted passages
        fetch_highlights
        # Because the web interface doesn't show us ALL of the highlights,
        #   we iterate and collect the authoritative highlights for each book
        collect_authoritative_highlights
      end

      private

      def agent
        @agent ||= Kindle::Parser::Agent.new.agent
      end

      def login
        @page = agent.get(SETTINGS.url + "/login")
        login_form = page.forms.first
        login_form.email    = @username
        login_form.password = @password
        @page = login_form.submit
      end

      # TODO: Handle CAPTCHA
      # def handle_captcha
      #   if page.css("#ap_captcha_img")
      #     puts "CAPTCHA LOGIN ERROR"
      #     save_and_open_page
      #     p page.link_with(text: /See a new challenge/).resolved_uri.to_s
      #     agent.cookie_jar.save("cookies.txt", format: :cookiestxt)
      #   end
      #   save_and_open_page
      #   rescue => exception
      #   end
      # end

      def collect_authoritative_highlights
        # NOTE: This fetch may fail if the highlight count is realy large.
        books.each do |book|
          next if book.highlight_count == 0
          kb = Kindle::Book.find_or_create_by(asin: book.asin, title: book.title, author: book.author)
          if kb.highlight_count != book.highlight_count
            kb.highlight_count = book.highlight_count
            kb.save!
          end
          url = "#{SETTINGS.url}/kcw/highlights?asin=#{book.asin}&cursor=0&count=#{book.highlight_count}"
          bpage = agent.get url
          items = JSON.parse(bpage.body).fetch("items", [])
          book.highlights = items.map do |item|
            kb.highlights.find_or_create_by(highlight: item["highlight"])
            # TODO: FIXME: amazon_id: item["embeddedId"]
          end
        end
      end

      def fetch_highlights(state={current_upcoming: [], asins: []})
        page = agent.get("#{SETTINGS.url}/your_highlights")
        initialize_state_with_page state, page
        highlights = extract_highlights_from_page(page, state)
        begin
          page = get_the_next_page(state, highlights.flatten)
          new_highlights = extract_highlights_from_page(page, state)
          highlights << new_highlights
        end until new_highlights.length == 0
        highlights.flatten
      end

      def extract_highlights_from_page(page, state)
        return [] if page.css(".yourHighlight").length == 0
        page.css(".yourHighlight").map do |hl|
          parse_highlight(hl, state)
        end
      end

      def initialize_state_with_page(state, page)
        return if (page/".yourHighlight").length == 0
        state[:current_asin] = (page/".yourHighlightsHeader").first.attributes["id"].value.split("_").first
        state[:current_upcoming] = (page/".upcoming").first.text.split(',') rescue []
        state[:title] = (page/".yourHighlightsHeader .title").text.to_s.strip
        state[:author] = (page/".yourHighlightsHeader .author").text.to_s.strip
        highlights_on_page = (page/".yourHighlightsHeader")
        state[:current_offset] = (highlights_on_page.collect{|h| h.attributes['id'].value }).first.split('_').last
        highlight_count = (highlights_on_page/".highlightCount#{state[:current_asin]}").text.to_i
        state[:current_number_of_highlights] = highlight_count
        @books << Kindle::Remote::Book.new(state[:current_asin], {author: state[:author], title: state[:title], highlight_count: highlight_count})
      end

      def get_the_next_page(state, previously_extracted_highlights = [])
        asins           = previously_extracted_highlights.map(&:asin).uniq
        asins_string    = asins.collect { |asin| "used_asins[]=#{asin}" } * '&'
        upcoming_string = state[:current_upcoming].map { |l| "upcoming_asins[]=#{l}" } * '&'
        url = "#{SETTINGS.url}/your_highlights/next_book?#{asins_string}&current_offset=#{state[:current_offset]}&#{upcoming_string}"
        ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Host' => "kindle.#{SETTINGS.domain}" }
        page = agent.get(url,[],"#{SETTINGS.url}/your_highlight", ajax_headers)
        initialize_state_with_page state, page
        page
      end

      def parse_highlight(hl, state)
        # TODO: highlight_id
        # highlight_id   = hl.xpath('//*[@id="annotation_id"]').first["value"]
        highlight_text = (hl/".highlight").text
        asin           = (hl/".asin").text
        highlight = Kindle::Remote::Highlight.new(highlight: highlight_text, asin: asin)
        highlight
      end
    end
  end
end
