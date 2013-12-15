module Kindle

  class Reader

    include Nokogiri
    
    KINDLE_URL = 'http://kindle.amazon.com'

    attr_reader :agent, :asins, :highlights

    def initialize(options = {:login => nil, :password => nil})
      @highlights = [] 
      @current_offset = 25
      @current_highlights = 1
      @current_upcoming = []
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) }
      @agent = Mechanize.new
      @agent.redirect_ok = true
      @agent.user_agent_alias = 'Windows IE 7'
    end

    def get_login_page
      page = @agent.get(KINDLE_URL)
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
      @asins = []
      page = page.link_with(:text => 'Your Highlights').click
      extract_highlights page
      until @current_highlights.length == 0 do
        page = next_highlights
      end
    end

    def extract_highlights(page)
      @current_highlights = hls = (page/".yourHighlight")
      asins = (page/".asin").collect{|asin| asin.text}
      if hls.length > 0 
        @current_upcoming = (page/".upcoming").first.text.split(',') rescue [] 
        @title  = (page/".yourHighlightsHeader .title").text.to_s.strip
        @author = (page/".yourHighlightsHeader .author").text.to_s.strip
        @current_offset = ((page/".yourHighlightsHeader").collect{|h| h.attributes['id'].value }).first.split('_').last
        (page/".yourHighlight").each do |hl|
          highlight = parse_highlight(hl)
          @highlights << highlight
          if !@asins.include?(highlight.asin)
            @asins << highlight.asin unless @asins.include?(highlight.asin)
          end
        end
      end
    end

    def next_highlights
      asins_string = @asins.map{|l| "used_asins[]=#{l}" } * '&'
      upcoming_string = @current_upcoming.map{|l| "upcoming_asins[]=#{l}" } * '&'
      current_offset = @current_offset 
      url = "https://kindle.amazon.com/your_highlights/next_book?#{asins_string}&current_offset=#{@current_offset}&#{upcoming_string}"
      ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Host' => 'kindle.amazon.com' }
      current_page = @agent.get(url,[],'https://kindle.amazon.com/your_highlight', ajax_headers)
      extract_highlights(current_page)
      current_page
    end

    def parse_highlight(hl)
      highlight = (hl/".highlight").text
      asin      = (hl/".asin").text
      Highlight.new(highlight, asin, @title, @author)
    end

    def get_kindle_highlights
      page = login
      fetch_highlights page
      highlights
    end

  end

end

