module Kindle

  class HighlightsParser

    include Nokogiri

    KINDLE_URL = 'http://kindle.amazon.com'
    KINDLE_HTTPS_URL = 'https://kindle.amazon.com'

    def initialize(options = {:login => nil, :password => nil})
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) }
    end

    def get_highlights
      state = {
                current_offset:   25,
                current_upcoming: []
              }

      page = login
      fetch_highlights(page, state)
    end

    private

    def agent
      return @agent if @agent
      @agent = Mechanize.new
      @agent.redirect_ok = true
      @agent.user_agent_alias = 'Windows IE 9'
      @agent
    end

    def get_login_page
      page = agent.get(KINDLE_URL)
      page.link_with(href: "#{KINDLE_HTTPS_URL}/login").click
    end

    def login
      login_form = get_login_page.forms.first
      login_form.email    = @login
      login_form.password = @password

      page = login_form.submit
      page.forms.first.submit
    end

    def fetch_highlights(page, state)
      page = get_the_first_highlight_page_from(page, state)

      highlights = []

      new_highlights = extract_highlights_from(page, state)

      until new_highlights.length == 0 do
        highlights << new_highlights
        page = get_the_next_page(state, highlights.flatten)
        new_highlights = extract_highlights_from(page, state)
      end

      highlights.flatten
    end

    def get_the_first_highlight_page_from(page, state)
      page = page.link_with(:text => 'Your Highlights').click
      initialize_state_with_page state, page
      page
    end

    def extract_highlights_from(page, state)
      return [] if (page/".yourHighlight").length == 0
      (page/".yourHighlight").map { |hl| parse_highlight(hl, state) }
    end

    def initialize_state_with_page(state, page)
      return if (page/".yourHighlight").length == 0
      state[:current_upcoming] = (page/".upcoming").first.text.split(',') rescue []
      state[:title] = (page/".yourHighlightsHeader .title").text.to_s.strip
      state[:author] = (page/".yourHighlightsHeader .author").text.to_s.strip
      state[:current_offset] = ((page/".yourHighlightsHeader").collect{|h| h.attributes['id'].value }).first.split('_').last
    end

    def get_the_next_page(state, previously_extracted_highlights = [])
      asins           = previously_extracted_highlights.map(&:asin).uniq
      asins_string    = asins.collect { |asin| "used_asins[]=#{asin}" } * '&'
      upcoming_string = state[:current_upcoming].map { |l| "upcoming_asins[]=#{l}" } * '&'
      url = "#{KINDLE_HTTPS_URL}/your_highlights/next_book?#{asins_string}&current_offset=#{state[:current_offset]}&#{upcoming_string}"
      ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Host' => 'kindle.amazon.com' }
      page = agent.get(url,[],"#{KINDLE_HTTPS_URL}/your_highlight", ajax_headers)

      initialize_state_with_page state, page

      page
    end

    def parse_highlight(hl, state)
      highlight_id = hl.xpath('//*[@id="annotation_id"]').first["value"]
      highlight    = (hl/".highlight").text
      asin         = (hl/".asin").text
      Highlight.new(highlight_id, highlight, asin, state[:title], state[:author])
    end

  end

end

