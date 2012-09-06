require 'spec_helper'
require 'motivation/motives/path'

describe Motivation::Motives::Path do
  context "on a mote" do
    context "with an implicit path" do
      subject do
        Motivation::Mote.new name: 'my_foo_bar',
          motives: [described_class]
      end

      describe "opt(:path)" do
        it "returns the underscored name of the mote" do
          subject.opt(:path).should == 'my_foo_bar'
        end
      end

      context "with a parent" do
        let :parent do
          Object.new
        end

        subject do
          Motivation::Mote.new name: 'my_foo_bar',
            parent: parent,
            motives: [described_class]
        end

        describe "opt(:path)" do
          it "returns the parent's path combined with the underscored name of the mote" do
            stub(parent).opt(:path) { 'parent_path' }
            subject.opt(:path).should == 'parent_path/my_foo_bar'
          end
        end

        context "and specifying filename" do
          subject do
            Motivation::Mote.new name: 'my_foo_bar',
              parent: parent,
              filename: 'FooFile',
              motives: [described_class]
          end

          describe "opt(:path)" do
            it "returns the parent's path combined with the filename of the mote" do
              stub(parent).opt(:path) { 'some/path' }
              subject.opt(:path).should == 'some/path/FooFile'
            end
          end
        end
      end
    end

    context "with an explicit path" do
      subject do
        Motivation::Mote.new name: 'some name',
          path: 'path/to/stuff',
          motives: [described_class]
      end

      describe "opt(:path)" do
        it "returns the path" do
          subject.opt(:path).should == 'path/to/stuff'
        end
      end

      context "with a parent" do
        let :parent do
          Object.new
        end

        subject do
          Motivation::Mote.new name: 'some name',
            parent: parent,
            path: 'path/to/stuff',
            motives: [described_class]
        end

        describe "opt(:path)" do
          it "ignores the parent's path" do
            dont_allow(parent).opt(:path)
            subject.opt(:path).should == 'path/to/stuff'
          end
        end
      end
    end
  end
end
