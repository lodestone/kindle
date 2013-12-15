module Kindle

  class Reader

    include Nokogiri
    
    KINDLE_URL = 'http://kindle.amazon.com'

    attr_reader :state

    def initialize(options = {:login => nil, :password => nil})
      @state = {}
      state[:current_offset] = 25
      state[:current_upcoming] = []
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) }
      agent = Mechanize.new
      agent.redirect_ok = true
      agent.user_agent_alias = 'Windows IE 7'
      state[:agent] = agent
    end

    def get_login_page
      page = state[:agent].get(KINDLE_URL)
      page.link_with(:text => "Sign in").click
    end

    def login
      login_page = get_login_page
      login_page.forms.first.email    = @login
      login_page.forms.first.password = @password
      page = login_page.forms.first.submit
      page.forms.first.submit
    end

    def fetch_highlights page
      state[:asins] = []
      page = page.link_with(:text => 'Your Highlights').click
      new_highlights = extract_highlights(page)
      highlights = []
      until new_highlights.length == 0 do
        highlights << new_highlights
        results = next_highlights
        page = results[:page]
        new_highlights = extract_highlights(page)
      end
      highlights.flatten
    end

    def extract_highlights(page)
      hls = (page/".yourHighlight")
      asins = (page/".asin").collect{|asin| asin.text}
      highlights = []
      if hls.length > 0 
        state[:current_upcoming] = (page/".upcoming").first.text.split(',') rescue [] 
        state[:title] = (page/".yourHighlightsHeader .title").text.to_s.strip
        state[:author] = (page/".yourHighlightsHeader .author").text.to_s.strip
        state[:current_offset] = ((page/".yourHighlightsHeader").collect{|h| h.attributes['id'].value }).first.split('_').last
        (page/".yourHighlight").each do |hl|
          highlight = parse_highlight(hl)
          highlights << highlight
          if !state[:asins].include?(highlight.asin)
            state[:asins] << highlight.asin unless state[:asins].include?(highlight.asin)
          end
        end
      end
      highlights
    end

    def next_highlights
      asins_string = state[:asins].map{|l| "used_asins[]=#{l}" } * '&'
      upcoming_string = state[:current_upcoming].map{|l| "upcoming_asins[]=#{l}" } * '&'
      current_offset = state[:current_offset]
      url = "https://kindle.amazon.com/your_highlights/next_book?#{asins_string}&current_offset=#{state[:current_offset]}&#{upcoming_string}"
      ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Host' => 'kindle.amazon.com' }
      page = state[:agent].get(url,[],'https://kindle.amazon.com/your_highlight', ajax_headers)
      highlights = extract_highlights page
      { page: page, highlights: highlights }
    end

    def parse_highlight(hl)
      highlight = (hl/".highlight").text
      asin      = (hl/".asin").text
      Highlight.new(highlight, asin, state[:title], state[:author])
    end

    def get_kindle_highlights
      page = login
      fetch_highlights page
    end

  end

end

