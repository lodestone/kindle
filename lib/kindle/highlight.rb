module Kindle
  class Highlight < ActiveRecord::Base

    attribute :amazon_id, :integer
    attribute :highlight, :text

    belongs_to :book

    # attr_reader :id, :highlight, :asin, :title, :author, :highlight_count

    # def initialize(id, highlight, asin, title, author, highlight_count)
    #   @id              = id
    #   @highlight       = highlight
    #   @asin            = asin
    #   @title           = title
    #   @author          = author
    #   @highlight_count = highlight_count
    # end

    # def to_csv
    #   "#{id},#{asin},#{author},#{title},#{highlight},highlight_count"
    # end
    #
    # def to_json
    #   {id: id, highlight: highlight, asin: asin, title: title, author: author, highlight_count: highlight_count}.to_json
    # end

  end
end
