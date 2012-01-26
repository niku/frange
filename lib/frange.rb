require "frange/version"

module Frange
  class Draft
    attr_writer :source
    attr_accessor :params

    def initialize
      @selector = ->(input){ true }
      @source = Enumerator.new {}
      @filters = []
      @unit = ->(input){ [input].each }
      @params = {}
    end

    def filter &block
      @filters << block
    end

    def source val = nil, &block
      @source = block_given? ? (Enumerator.new &block) : val
    end

    def selector &block
      @selector = block
    end

    def unit &block
      @unit = block
    end

    def _filters
      @filters
    end

    def _source
      @source
    end

    def _selector
      @selector
    end

    def _unit
      @unit
    end

    def to_pipe
      Pipe.new(self)
    end
  end

  class Pipe
    def initialize draft
      @draft = draft
    end

    def new params = {}
      @draft.params = params
      source = @draft._source.clone
      selector = @draft._selector
      filters  = @draft._filters
      unit     = @draft._unit
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

  def self.pipe &block
    builder = Draft.new
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
