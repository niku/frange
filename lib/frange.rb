require "frange/version"
require "frange/pipe"
require "frange/builder"

module Frange
  def self.piping &block
    builder = Builder.new
    builder.instance_eval &block if block_given?
    builder.to_pipe
  end
end
