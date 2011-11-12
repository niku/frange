module Frange
  class Pipe
    attr_accessor :source
    attr_reader :filters

    def initialize
      @filters = []
    end

    def add_filter filter
      @filters << filter
    end

    def next
      @filters.reduce(@source.next){ |s,f| f.call(s) }
    end
  end
end
