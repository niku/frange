require "frange/version"

module Frange
  class Draft
    attr_accessor :selector, :source, :unit, :params
    attr_reader :filters

    def initialize
      @selector = ->(input){ true }
      @source = Enumerator.new {}
      @filters = []
      @unit = ->(input){ [input].each }
    end

    def add_filter filter
      @filters << filter
    end
  end

  class Pipe
    def initialize draft
      @draft = draft
    end

    def new params = {}
      @draft.params = params
      source   = @draft.source.clone
      selector = @draft.selector
      filters  = @draft.filters
      unit     = @draft.unit
      Bucket.new { |y|
        loop do
          source.next until selector.call(source.peek)
          filtered = filters.reduce(source.next){ |s,f| f.call(s) }
          unit.call(filtered).each{ |u| y << u }
        end
      }
    end
  end

  class Bucket < Enumerator; end

  class Builder
    def initialize
      @draft = Draft.new
    end

    def filter &block
      @draft.add_filter block
    end

    def source val = nil, &block
      @draft.source = block_given? ? (Enumerator.new &block) : val
    end

    def selector &block
      @draft.selector = block
    end

    def unit &block
      @draft.unit = block
    end

    def params
      @draft.params
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

  def self.bucket &block
    if block_given?
      self.pipe(&block).new
    else
      self.pipe.new
    end
  end
end
