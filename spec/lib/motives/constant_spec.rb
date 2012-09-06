require 'spec_helper'
require 'motivation/motives/constant'

describe Motivation::Motives::Constant do
  context "on a mote" do
    context "with an implicit constant name" do
      subject do
        Motivation::Mote.new name: 'implicit_constant',
          motives: [described_class]
      end

      describe "opt(:constant_name)" do
        it "returns the camelized name of the mote" do
          subject.opt(:constant_name).should == 'ImplicitConstant'
        end
      end

      describe "#constant" do
        before do
          ImplicitConstant = 'constant value'
        end

        after do
          Object.instance_eval { remove_const :ImplicitConstant }
        end

        it "returns the constant" do
          subject.constant.should == ImplicitConstant
        end
      end
    end

    context "with an explicit constant name" do
      subject do
        Motivation::Mote.new name: 'irrelevant name',
          constant_name: 'Explicit_constant',
          motives: [described_class]
      end

      describe "opt(:constant_name)" do
        it "returns the constant name" do
          subject.opt(:constant_name).should == 'Explicit_constant'
        end
      end

      describe "#constant" do
        before do
          Explicit_constant = 'constant value'
        end

        after do
          Object.instance_eval { remove_const :Explicit_constant }
        end

        it "returns the constant" do
          subject.constant.should == Explicit_constant
        end
      end
    end
  end
end

