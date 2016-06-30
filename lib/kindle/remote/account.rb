# module Kindle
#   module Remote
#     class Account
#       attr_accessor :login, :password
#
#       def initialize(login=nil, password=nil)
#         @login = login || ENV['AMAZON_USERNAME']
#         @password = password || ENV['AMAZON_PASSWORD']
#       end
#
#       def highlights
#         @highlights = HighlightsParser.new(login: @login, password: @password).get_highlights
#       end
#     end
#   end
# end
