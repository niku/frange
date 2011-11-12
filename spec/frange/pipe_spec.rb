require "spec_helper"

module Frange
  describe Pipe do
    describe "Pipe#next" do
      context "when default" do
        it{ expect{ subject.next }.to raise_exception } # TODO How to behave?
      end
      context "given source" do
        subject do
          pipe = Pipe.new
          pipe.source = %w(a b).to_enum
          pipe
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
          pipe = Pipe.new
          pipe.source = %w(a b).to_enum
          pipe.add_filter ->(input){ input + "1" }
          pipe.add_filter ->(input){ input + "2" }
          pipe
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
