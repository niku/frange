module Frange
  module Pipe
    attr_accessor :source

    def initialize
      @source = self.class.source.clone || Enumerator.new
    end

    def selector
      self.class.selector || ->(input){ true }
    end

    def filters
      self.class.filters || []
    end

    def next
      call_once = false
      call_once, matched = true, @source.next until selector.call(@source.peek)
      filters.reduce(call_once ? matched : @source.next){ |s,f| f.call(s) }
    end

    # define class method's
    def self.included(mod)
      mod.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :selector, :source
      attr_reader :filters

      def add_filter filter
        @filters ||= []
        @filters << filter
      end
    end
  end
end
