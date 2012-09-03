require 'spec_helper'

describe Motivation::Motives::Constant do
  context "on a mote" do
    context "which specifies constant_name" do
      subject do
        Motivation::Mote.new name: 'constant mote',
          constant_name: 'MyConstant',
          motives: [described_class]
      end

      before do
        MyConstant = 'constant value'
      end

      after do
        Object.instance_eval { remove_const :MyConstant }
      end

      describe "#constant" do
        it "returns the constant" do
          subject.constant.should == MyConstant
        end
      end
    end

    context "which doesn't specify constant_name" do
      subject do
        Motivation::Mote.new name: 'constant mote',
          motives: [described_class]
      end

      describe "#constant" do
        it "raises an opt error" do
          lambda { subject.constant }.should raise_opt_error(:constant_name)
        end
      end
    end
  end
end
