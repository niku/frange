require "spec_helper"

module Frange
  describe Pipe do
    describe "#next" do
      subject { Class.new{ include Pipe }.new }
      context "when default" do
        it{ expect{ subject.next }.to raise_exception } # TODO How to behave?
      end
      context "given source" do
        subject do
          klass = Class.new{ include Pipe }
          klass.source = %w(a b).to_enum
          klass.new
        end
        context "when called twice" do
          it{
            ary = []
            2.times{ ary << subject.next }
            ary.should eq ["a", "b"]
          }
        end
        context "when called 3 times" do
          it{ expect{ 3.times{ subject.next } }.to raise_exception(StopIteration) }
        end
      end
      context "given source and filter" do
        subject do
          klass = Class.new{ include Pipe }
          klass.source = %w(a b).to_enum
          klass.add_filter ->(input){ input + "1" }
          klass.add_filter ->(input){ input + "2" }
          klass.new
        end
        context "when called twice" do
          it{
            ary = []
            2.times{ ary << subject.next }
            ary.should eq ["a12", "b12"]
          }
        end
      end
    end
  end
end
