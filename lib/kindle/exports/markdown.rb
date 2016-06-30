module Kindle
  module Exports
    class Markdown
      def initialize(books)
        @document = "## Kindle Highlights\n\n"
        books.each do |book|
          @document << "\n### #{book.title} by #{book.author}\n\n"
          book.highlights.each do |highlight|
            @document << "> #{highlight.highlight}\n\n"
          end
        end
      end
      def to_s
        @document
      end
    end
  end
end
