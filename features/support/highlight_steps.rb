require "kindle"
require 'cucumber/timecop'

Given(/^a database exists$/) do
  Kindle::Models::Book.delete_all
  Kindle::Models::Highlight.delete_all
  book = Kindle::Models::Book.create! title: "Zen", author: "Monk", highlight_count: 1
  highlight = book.highlights.create! highlight: "Reach for enlightenment"
end

Given(/^time is frozen$/) do
  Timecop.freeze(Time.local(1990))
end
