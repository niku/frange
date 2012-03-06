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
        @source = {}
        @selector = ->(input){ true }
        @filters = []
        super() { |y|
          source = case
                   when block = @source[:block]
                     if block.arity == 1
                       Enumerator.new &block
                     else
                       Enumerator.new &block.curry.call(params)
                     end
                   when @source.include?(:args); Enumerator.new @source[:obj], @source[:method], @source[:args]
                   else Enumerator.new @source[:obj], @source[:method]
                   end
          selector = @selector.arity == 1 ? @selector : @selector.curry.call(params)
          filters = @filters.map { |f| f.arity == 1 ? f : f.curry.call(params) }
          loop do
            source.next until selector.call(source.peek)
            y << filters.reduce(source.next) { |s,f| f.call(s) }
          end
        }
      end

      protected
      def filter &block
        @filters << block
      end

      def source obj=[], method = :each, *args, &block
        @source = case
                  when block_given?; { block: block }
                  when *args.empty?; { obj: obj, method: method }
                  else { obj: obj, method: method, args: args }
                  end
      end

      def selector &block
        @selector = block
      end
    end
  end
end
