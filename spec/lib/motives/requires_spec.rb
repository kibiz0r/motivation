require 'spec_helper'
require 'motivation/motives/requires'

describe Motivation::Motives::Requires do
  context "on a mote" do
    let :parent do
      Motivation::Container.new motives: [described_class]
    end

    let(:motes) { [@foo, @bar] }

    before do
      @foo = parent.mote! 'foo'
      @bar = parent.mote! 'bar'
      stub(@foo).file { 'foo.rb' }
      stub(@bar).file { 'bar.rb' }
    end

    describe "#required_motes" do
      context "by default" do
        subject do
          Motivation::Mote.new parent: parent,
            motives: [described_class]
        end

        it "is an empty array" do
          subject.required_motes.should == []
        end
      end

      context "with requires: 'foo'" do
        subject do
          Motivation::Mote.new parent: parent,
            motives: [described_class],
            requires: 'foo'
        end

        let(:motes) { [@foo] }

        it "returns the found mote" do
          subject.required_motes.should == motes
        end
      end

      context "with requires: ['foo', 'bar']" do
        subject do
          Motivation::Mote.new parent: parent,
            motives: [described_class],
            requires: ['foo', 'bar']
        end

        it "returns the found motes" do
          subject.required_motes.should == motes
        end
      end
    end

    describe "#required_mote_files" do
      context "by default" do
        subject do
          Motivation::Mote.new parent: parent,
            motives: [described_class]
        end

        it "is an empty array" do
          subject.required_mote_files.should == []
        end
      end

      context "with requires: 'foo'" do
        subject do
          Motivation::Mote.new parent: parent,
            motives: [described_class],
            requires: 'foo'
        end

        let(:motes) { [@foo] }

        it "returns the required mote's file" do
          subject.required_mote_files.should == ['foo.rb']
        end
      end

      context "with requires: ['foo', 'bar']" do
        subject do
          Motivation::Mote.new parent: parent,
            motives: [described_class],
            requires: ['foo', 'bar']
        end

        it "returns the required motes' files" do
          subject.required_mote_files.should == ['foo.rb', 'bar.rb']
        end
      end
    end
  end
end

