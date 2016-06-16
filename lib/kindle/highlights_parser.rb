require "mechanize"
require "nokogiri"
require "json"

class Kindle

  class HighlightsParser

    attr_accessor :page, :highlights
    attr_reader :books

    def initialize(username=Kindle.settings.username, password=Kindle.settings.password, options={})
      @login    = username
      @password = password
      @books    = []
      @highlights = []
      @update = options[:update]
      load_highlights
    end

    def load_highlights
      login
      if !cache_exists || updating?
        fetch_highlights
        cache_initial_results
      else
        puts "Loading from cache"
        load_initial_cache
      end
      collect_authoritative_highlights
    end
    # alias :get_highlights :load_highlights


    def agent
      @agent ||= Kindle::Agent.new.agent
    end

    private

    def cache_file
      ".kindle.books.initial.cache"
    end

    def updating?
      false
    end

    def cache_exists
      File.exists?(cache_file)
    end

    def cache_initial_results
      file = File.open(cache_file, "w+")
      file << Marshal.dump(books)
    end

    def load_initial_cache
      file = File.open(cache_file, "r").read
      @books = Marshal.load(file)
    end

    def save_and_open_page
      File.open("html.html", "w+") {|html| html << page.body }
      %x[open html.html]
    end

    def login
      # begin
        @page = agent.get(Kindle.settings.url + "/login")
        login_form = page.forms.first
        login_form.email    = @login
        login_form.password = @password
        @page = login_form.submit
        # if page.css("#ap_captcha_img")
        #   puts "CAPTCHA LOGIN ERROR"
        #   save_and_open_page
        #   # p page.link_with(text: /See a new challenge/).resolved_uri.to_s
        #   p agent.cookie_jar.jar
        #   agent.cookie_jar.save("cookies.txt", format: :cookiestxt)
        # end
        # save_and_open_page
      # rescue => exception
        # puts exception
        # puts page.methods.sort
      # end
    end

    def write_authoritative_kindle_data
      File.open(".kindle.books.cache", "w+") << Marshal.dump(books)
      File.open(".kindle.highlights.cache", "w+") << Marshal.dump(highlights)
    end

    def collect_authoritative_highlights
      books.each do |book|
        book.asin
        url = "https://kindle.amazon.com/kcw/highlights?asin=#{book.asin}&cursor=0&count=#{book.highlight_count}"
        bpage = agent.get url
        items = JSON.parse(bpage.body).fetch("items", [])
        book.highlights = items.map do |item|
          Kindle::Highlight.new(item["embeddedId"], item["highlight"], item["asin"], book.title, book.author, book.highlight_count)
        end
      end
      write_authoritative_kindle_data
    end

    def fetch_highlights(state={current_upcoming: [], asins: []})
      page = agent.get("#{Kindle.settings.url}/your_highlights")
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
      @books << Kindle::Book.new(state[:current_asin], {author: state[:author], title: state[:title], highlight_count: highlight_count})
    end

    def get_the_next_page(state, previously_extracted_highlights = [])
      asins           = previously_extracted_highlights.map(&:asin).uniq
      asins_string    = asins.collect { |asin| "used_asins[]=#{asin}" } * '&'
      upcoming_string = state[:current_upcoming].map { |l| "upcoming_asins[]=#{l}" } * '&'
      url = "#{Kindle.settings.url}/your_highlights/next_book?#{asins_string}&current_offset=#{state[:current_offset]}&#{upcoming_string}"
      ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Host' => "kindle.#{Kindle.settings.domain}" }
      page = agent.get(url,[],"#{Kindle.settings.url}/your_highlight", ajax_headers)
      initialize_state_with_page state, page
      page
    end

    def parse_highlight(hl, state)
      highlight_id   = hl.xpath('//*[@id="annotation_id"]').first["value"]
      highlight_text = (hl/".highlight").text
      asin           = (hl/".asin").text
      highlight_count = (hl/".highlightCount#{asin}").text
      highlight = Kindle::Highlight.new(highlight_id, highlight_text, asin, state[:title], state[:author], highlight_count)
      highlight
    end

  end

end
