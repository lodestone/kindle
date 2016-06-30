module Kindle
  module Exports
    class Csv
      def initialize(highlights)
        @document = "highlight,book title,book author,book asin\n"
        highlights.each do |h|
          @document << "\"#{h.highlight}\",\"#{h.book.title}\",\"#{h.book.author}\",#{h.book.asin}\n"
        end
      end
      def to_s
        @document
      end
    end
  end
end
