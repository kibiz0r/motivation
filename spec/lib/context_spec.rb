require 'spec_helper'

describe Motivation::Context do
  describe "#resolve!" do
    context "when the mote exists" do
      before do
        @foo = subject.mote! :foo
      end

      it "returns the mote" do
        subject.resolve!(:foo).should == @foo
      end
    end

    context "when the mote doesn't exist" do
      context "and there are no resolvers" do
        it "returns nil" do
          subject.resolve!(:foo).should be_nil
        end
      end

      context "and there are resolvers" do
        let :resolver1 do
          Object.new
        end

        let :resolver2 do
        end

        let :resolvers do
          [resolver1, resolver2]
        end

        it "takes the first non-nil result from asking resolvers" do
          mock(resolver1).resolve!(:foo) { nil }
          stub(resolver2).resolve!(:foo) { :bar }
          subject.resolvers = resolvers
          subject.resolve!(:foo).should == :bar
        end
      end
    end
  end
end
