module Frange
  class Builder
    def initialize
      @pipe = Class.new{ include Pipe }
    end

    def filter &block
      @pipe.add_filter block
    end

    def source val
      @pipe.source = val
    end

    def selector &block
      @pipe.selector = block
    end

    def to_pipe
      @pipe
    end
  end
end

