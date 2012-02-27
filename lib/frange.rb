require "frange/version"

module Frange
  autoload :Sources, "frange/sources"
  autoload :Selectors, "frange/selectors"
  autoload :Filters, "frange/filters"

  def self.draft &block
    draft = Core::Draft.new
    draft.config = block
    draft
  end

  module Core
    class Draft
      attr_accessor :config

      def build params = {}
        pipe = Pipe.new
        pipe.params = params
        pipe.instance_eval &config
        pipe
      end
    end

    class Pipe < Enumerator
      attr_accessor :params

      def initialize
        @source = Enumerator.new([])
        @selector = ->(input){ true }
        @filters = []
        super() { |y|
          selector = @selector.arity == 1 ? @selector : @selector.curry.call(params)
          filters = @filters.map { |f| f.arity == 1 ? f : f.curry.call(params) }
          loop do
            @source.next until selector.call(@source.peek)
            y << filters.reduce(@source.next) { |s,f| f.call(s) }
          end
        }
      end

      protected
      def filter &block
        @filters << block
      end

      def source obj=[], method = :each, *args, &block
        @source = case
                  when block_given?; Enumerator.new &block
                  when *args.empty?; Enumerator.new obj, method
                  else Enumerator.new obj, method, *args
                  end
      end

      def selector &block
        @selector = block
      end
    end
  end
end
