module Frange
  class Pipe
    attr_accessor :source, :selector
    attr_reader :filters

    def initialize
      @selector = ->(input){ true }
      @filters = []
    end

    def add_filter filter
      @filters << filter
    end

    def next
      call_once = false
      call_once, matched = true, @source.next until @selector.call(@source.peek)
      @filters.reduce(call_once ? matched : @source.next){ |s,f| f.call(s) }
    end
  end
end
