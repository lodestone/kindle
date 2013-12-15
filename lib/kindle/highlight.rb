module Kindle

  class Highlight

    attr_reader :highlight, :asin, :title, :author

    def initialize(highlight, asin, title, author)
      @highlight, @asin, @title, @author = highlight, asin, title, author
    end

  end

end
