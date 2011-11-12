module Frange
  class Builder
    def initialize
      @pipe = Pipe.new
    end

    def filter &block
      @pipe.add_filter block
    end

    def source val
      @pipe.source = val
    end

    def to_pipe
      @pipe
    end
  end
end

