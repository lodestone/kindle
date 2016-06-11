module Kindle
  class Highlight
    attr_reader :id, :highlight, :asin, :title, :author

    def initialize(id, highlight, asin, title, author)
      @id        = id
      @highlight = highlight
      @asin      = asin
      @title     = title
      @author    = author
    end
  end
end
