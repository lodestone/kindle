module Kindle
  module Exports
    class Json
      def initialize(highlights)
        @document = highlights.to_json(include: :book)
      end
      def to_s
        @document
      end
    end
  end
end
