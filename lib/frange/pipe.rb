module Frange
  module Pipe
    def initialize source = nil
      source ||= self.class.source.clone
      @source = Enumerator.new { |y|
        loop do
          source.next until selector.call(source.peek)
          y << filters.reduce(source.next){ |s,f| f.call(s) }
        end
      }
    end

    def source
      @source.clone
    end

    def selector
      self.class.selector
    end

    def filters
      self.class.filters
    end

    def next
      @source.next
    end

    def peek
      @source.peek
    end

    # define draft
    def self.included(mod)
      mod.extend Draft
    end

    module Draft
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
        @source = Enumerator.new {}
        @filters = []
      end
    end
  end
end
