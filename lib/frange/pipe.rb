module Frange
  module Pipe
    attr_accessor :source

    def initialize
      @source = self.class.source.clone
    end

    def selector
      self.class.selector
    end

    def filters
      self.class.filters
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

      def self.extended(mod)
        mod.module_eval { module_initialize }
      end

      def add_filter filter
        @filters << filter
      end

      private
      def module_initialize
        @selector = ->(input){ true }
        @source = [].to_enum
        @filters = []
      end
    end
  end
end
