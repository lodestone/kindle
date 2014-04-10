module Kindle

  class Highlight

    attr_reader :id, :highlight, :asin, :title, :author

    def initialize(id, highlight, asin, title, author)
      @id, @highlight, @asin, @title, @author = id, highlight, asin, title, author
    end

  end

end
