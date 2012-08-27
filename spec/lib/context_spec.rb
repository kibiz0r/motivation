require 'spec_helper'

describe Motivation::Context do
  describe "[:foo]" do
    subject do
      described_class.new do
        motivation 'spec/data'
        foo
      end
    end

    it "returns Foo" do
      subject[:foo].should == Foo
    end

    context "with a string key" do
      it "still returns Foo" do
        subject['foo'].should == Foo
      end
    end
  end

  describe "#path_for(:foo)" do
    subject do
      described_class.new do
        foo
      end
    end

    it "returns lib/foo.rb" do
      subject.path_for(:foo).should == 'lib/foo.rb'
    end

    context "when path_root == '.'" do
      subject do
        described_class.new do
          motivation '.'
          foo
        end
      end

      it "returns ./foo.rb" do
        subject.path_for(:foo).should == './foo.rb'
      end
    end
  end
end
