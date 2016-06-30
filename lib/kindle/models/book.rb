module Kindle
  module Models
    class Book < ActiveRecord::Base

      attribute :asin, :string
      attribute :highlight_count, :integer
      attribute :title, :string
      attribute :author, :string

      has_many :highlights

      # def initialize(asin, options = {})
      #   @asin            = asin
      #   @title           = options[:title]
      #   @author          = options[:author]
      #   @highlight_count = options[:highlight_count]
      #   @highlights      = []
      # end

      # def to_csv
      #   "#{id},#{asin},#{author},#{title},#{highlight},highlight_count"
      # end

    end
  end
end
