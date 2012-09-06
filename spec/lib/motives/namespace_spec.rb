require 'spec_helper'
require 'motivation/motives/namespace'

describe Motivation::Motives::Namespace do
  describe "#namespace" do
    context "on a container" do
      context "without a parent" do
        subject do
          Motivation::Container.new name: 'my_namespace',
            motives: [described_class]
        end
        
        it "is the container's name camelized" do
          subject.namespace.should == '::MyNamespace'
        end

        context "that specifies namespace: true" do
          subject do
            Motivation::Container.new name: 'my_namespace',
              namespace: true,
              motives: [described_class]
          end

          it "is still the container's name camelized" do
            subject.namespace.should == '::MyNamespace'
          end
        end
      end

      context "with a parent" do
        let :parent do
          Motivation::Container.new name: 'parent',
            motives: [described_class]
        end

        subject do
          Motivation::Container.new name: 'child',
            parent: parent,
            motives: [described_class]
        end

        it "is the concatenation of its parent's namespace and its calculated namespace" do
          subject.namespace.should == '::Parent::Child'
        end

        context "that specifies namespace: true" do
          let :parent do
            Motivation::Container.new name: 'parent',
              namespace: true,
              motives: [described_class]
          end

          it "is still the concatenation of its parent's namespace and its calculated namespace" do
            subject.namespace.should == '::Parent::Child'
          end
        end
      end
    end

    context "on a mote" do
      let :parent do
        Motivation::Container.new name: 'parent_namespace',
          motives: [described_class]
      end

      subject do
        Motivation::Mote.new name: '',
          parent: parent,
          motives: [described_class]
      end

      it "is its parent's namespace" do
        subject.namespace.should == '::ParentNamespace'
      end
    end
  end
end

