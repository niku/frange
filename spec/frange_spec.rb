require "spec_helper"

module Frange
  describe ".draft" do
    let(:source_array){ ["a", 1, "b", 2, "c"] }

    context "given parameter" do
      let(:put_parameter){ { a: "foo" } }
      subject do
        Frange.draft { |d|
          d.source { |y| y << params[:a] }
        }.build(put_parameter)
      end
      it { subject.next.should eq put_parameter[:a] }
    end

    context "when source setuped" do
      context "by Enumrator" do
        subject do
          array = source_array # can't find source_array in draft block
          Frange.draft { |d|
            d.source array
          }.build
        end
        it { subject.take(5).should eq source_array }
      end
      context "by block" do
        subject do
          Frange.draft { |d|
            d.source { |y|
              y << :a
              y << :b
            }
          }.build
        end
        it { subject.next.should eq :a  }
        it {
          subject.next
          subject.next.should eq :b
        }
      end
    end

    context "when selector setuped" do
      subject do
        array = source_array
        Frange.draft { |d|
          d.source array
          d.selector { |i| i.kind_of?(Numeric) }
        }.build
      end
      it { subject.next.should eq 1 }
      it {
        subject.next
        subject.next.should eq 2
      }
    end

    context "when filter setuped" do
      subject do
        array = source_array
        Frange.draft { |d|
          d.source array
          d.filter { |i| '_' + i.to_s + '_' }
          d.filter { |i| '{' + i.to_s + '}' }
        }.build
      end
      it { subject.next.should eq "{_a_}"}
    end
  end

  # advanced
  describe "nested" do
    subject do
      Frange.draft { |d|
        d.source Frange.draft { |inner| # you must not use "do end" block!
          inner.source { |y| y << params[:inner] }
        }.build(params)
        d.filter { |input| params[:outer] + input + params[:outer] }
      }.build(outer: "o", inner: "i")
    end
    it { subject.next.should eq "oio"}
  end
end
