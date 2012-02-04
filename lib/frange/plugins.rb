require "rss"

module Frange
  module Plugins
    ParsedRSSEntries = Frange.draft { |d| d.source ::RSS::Parser.parse(params[:doc], false).entries }
  end
end
