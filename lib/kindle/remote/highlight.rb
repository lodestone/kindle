module Kindle
  module Remote
    class Highlight
      attr_accessor :highlight, :amazon_id, :asin
      def initialize(options = {})
        @highlight = options[:highlight]
        @amazon_id = options[:amazon_id]
        @asin = options[:asin]
      end
    end
  end
end
