require_relative "spec_helper"

module Frange
  describe Pipe do
    describe "#next" do
      context "when default" do
        it{ expect{ subject.next }.to raise_exception } # TODO How to behave?
      end
      context "given source" do
        subject do
          draft = Draft.new
          draft.source = %w(a b).to_enum
          pipe = Pipe.new(draft)
          pipe.new
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
          draft = Draft.new
          draft.source = %w(a b).to_enum
          draft.add_filter ->(input){ input + "1" }
          draft.add_filter ->(input){ input + "2" }
          pipe = Pipe.new(draft)
          pipe.new
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

  describe "Frange.piping" do
    context "given with source" do
      subject {
        Frange.valve { |pipe|
          pipe.source ["a", 1, "b", 2, "c"].to_enum
          pipe.selector { |input| input.kind_of?(String) }
          pipe.filter { |input| input + "1" }
          pipe.filter { |input| input + "2" }
          pipe.filter { |input| input + "3" }
        }
      }
      it{ should be_kind_of Frange::Valve }
      it{ subject.should have(3).filters }
      it{ subject.next.should eq "a123" }
    end
    context "given unit"do
      subject {
        Frange.valve do |pipe|
          pipe.source [[1,2,3,4]].each
          pipe.unit { |input| input.each }
        end
      }
      it { subject.next.should be 1 }
    end
    context "given with nested source" do
      subject {
        Frange.valve do |pipe|
          pipe.source Frange.valve { |inner|
            inner.source ["a", 1, "b", 2, "c"].to_enum
            inner.selector { |input| input.kind_of?(String) }
            inner.filter { |input| input + "1" }
          }
          pipe.filter { |input| input + "2" }
          pipe.filter { |input| input + "3" }
        end
      }
      it{ should be_kind_of Frange::Valve }
      it{ subject.should have(3).filters }
      it{ subject.next.should eq "a123" }
    end
  end
end
