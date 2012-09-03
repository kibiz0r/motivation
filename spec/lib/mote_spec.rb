require 'spec_helper'

describe Motivation::Mote do
  context "with arbitrary opts" do
    subject do
      described_class.new foo: 'bar'
    end

    it "exposes opts as #args" do
      subject.args.should == { foo: 'bar' }
    end

    context "and a name" do
      subject do
        described_class.new name: 'my_mote', foo: 'bar'
      end

      it "excludes name from #args" do
        subject.args.should == { foo: 'bar' }
      end
    end
  end

  describe "#resolve!" do
    subject do
      described_class.new name: 'my_mote'
    end

    context "when mote doesn't respond to #constant" do
      it "raises an error" do
        lambda { subject.resolve! }.should raise_method_error(:constant, from: 'Mote#resolve!')
      end
    end

    context "when mote responds to #constant" do
      before do
        def subject.constant
          :foo
        end
      end

      it "returns #constant" do
        subject.resolve!.should == :foo
      end
    end
  end

  describe "#opt" do
    context "when a motive declares the opt" do
      let :motive do
        Module.new.tap do |m|
          stub(m).opt_name { 'arch' }
        end
      end

      context "and the mote doesn't override it" do
        subject do
          described_class.new motives: [motive]
        end

        it "asks the motive for the opt value" do
          stub(motive).process_opt(subject, :arch) { 'way' }
          subject.opt(:arch).should == 'way'
        end
      end

      context "and the mote overrides it" do
        subject do
          described_class.new motives: [motive], arch: 'nemesis'
        end

        it "uses the overriden value" do
          dont_allow(motive).process_opt(:arch)
          subject.opt(:arch).should == 'nemesis'
        end
      end
    end
  end
end
