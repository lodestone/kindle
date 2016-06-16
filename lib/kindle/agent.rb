class Kindle
  class Agent
    def initialize()
    end
    def agent
      return @agent if @agent
      @agent = Mechanize.new
      @agent.redirect_ok = true
      @agent.user_agent_alias = 'Mac Mozilla'
      @agent
    end
  end
end
