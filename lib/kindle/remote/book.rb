module Kindle
  module Remote
    class Book
      attr_accessor :asin, :title, :author, :highlight_count, :highlights
      def initialize(asin, options = {})
        @asin            = asin
        @title           = options[:title]
        @author          = options[:author]
        @highlight_count = options[:highlight_count]
        @highlights      = []
      end
    end
  end
end
