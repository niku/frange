require "frange/version"

module Frange
  class Draft
    attr_accessor :selector, :source
    attr_reader :filters

    def initialize
      @selector = ->(input){ true }
      @source = Enumerator.new {}
      @filters = []
    end

    def add_filter filter
      @filters << filter
    end
  end

  class Pipe
    def initialize draft
      @draft = draft
    end

    def new source = nil
      source   = source || @draft.source.clone
      selector = @draft.selector
      filters  = @draft.filters
      Valve.new { |y|
        loop do
          source.next until selector.call(source.peek)
          y << filters.reduce(source.next){ |s,f| f.call(s) }
        end
      }
    end
  end

  class Valve < Enumerator; end

  class Builder
    def initialize
      @draft = Draft.new
    end

    def filter &block
      @draft.add_filter block
    end

    def source val
      @draft.source = val
    end

    def selector &block
      @draft.selector = block
    end

    def to_pipe
      Pipe.new(@draft)
    end
  end

  def self.pipe &block
    builder = Builder.new
    builder.instance_eval &block if block_given?
    builder.to_pipe
  end

  def self.valve &block
    if block_given?
      self.pipe(&block).new
    else
      self.pipe.new
    end
  end
end
