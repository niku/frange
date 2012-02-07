require "rss"

module Frange
  module Sources
    ParsedRSSEntries = Frange.draft { |d| d.source ::RSS::Parser.parse(params[:doc], false).entries }
  end
end
