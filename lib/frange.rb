require "frange/version"

module Frange
  def self.draft &block
    draft = Draft.new
    draft.config = block
    draft
  end

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
      @source = Enumerator.new {}
      @selector = ->(input){ true }
      @filters = []
      super() { |y|
        loop do
          @source.next until @selector.call(@source.peek)
          y << @filters.reduce(@source.next){ |s,f| f.call(s) }
        end
      }
    end

    protected
    def filter &block
      @filters << block
    end

    def source val = nil, &block
      @source = block_given? ? (Enumerator.new &block) : val
    end

    def selector &block
      @selector = block
    end
  end
end
