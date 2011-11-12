require_relative "spec_helper"

describe Frange do
  describe "Frange.piping" do
    context "given with source" do
      subject {
        Frange.piping do |pipe|
          pipe.source ["a", "b", "c"].to_enum
          pipe.filter { |input| input + "1" }
          pipe.filter { |input| input + "2" }
          pipe.filter { |input| input + "3" }
        end
      }
      it{ should be_kind_of Frange::Pipe }
      it{ subject.should have(3).filters }
      it{ subject.next.should eq "a123" }
    end
  end
end
