class Kindle
  class Book
    attr_reader :asin, :highlight_count, :title, :author
    attr_accessor :highlights

    def initialize(asin, options = {})
      @asin            = asin
      @title           = options[:title]
      @author          = options[:author]
      @highlight_count = options[:highlight_count]
      @highlights      = []
    end

    # def to_csv
    #   "#{id},#{asin},#{author},#{title},#{highlight},highlight_count"
    # end

  end
end
