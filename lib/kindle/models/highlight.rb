module Kindle
  module Models
    class Highlight < ActiveRecord::Base

      attribute :amazon_id, :integer
      attribute :highlight, :text

      belongs_to :book

      # def to_csv
      #   "#{id},#{asin},#{author},#{title},#{highlight},highlight_count"
      # end
      #
      # def to_json
      #   {id: id, highlight: highlight, asin: asin, title: title, author: author, highlight_count: highlight_count}.to_json
      # end

      # def as_json
      #   {id: id, highlight: highlight, asin: book.asin, title: book.title, author: book.author}
      # end

    end
  end
end
