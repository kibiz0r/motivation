require 'spec_helper'

describe Motivation::Mote do
  describe "#locate_mote" do
    context "without a context" do
      it "returns nil" do
        subject.locate_mote(:foo).should be_nil
      end
    end

    context "with a context" do
      let :context do
        Object.new
      end

      subject do
        described_class.new context: context
      end

      it "returns the context's located mote" do
        stub(context).locate_mote(:foo) { :located_foo }
        subject.locate_mote(:foo).should == :located_foo
      end
    end
  end

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

    it "returns nil by default" do
      subject.resolve!.should be_nil
    end
  end

  describe "#opt" do
    context "when a motive declares the opt" do
      let :motive do
        Module.new.tap do |m|
          stub(m).opts { [:arch] }
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
