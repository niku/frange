require "frange/version"

module Frange
  autoload :Pipe,    "frange/pipe"
  autoload :Builder, "frange/builder"

  def self.piping &block
    builder = Builder.new
    builder.instance_eval &block if block_given?
    builder.to_pipe
  end
end
