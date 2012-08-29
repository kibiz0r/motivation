require 'spec_helper'

describe Motivation::Container do
  context "with arbitrary opts" do
    subject do
      described_class.new foo: 'bar'
    end

    it "makes opts available as args" do
      subject.args.should == { foo: 'bar' }
    end

    context "within a parent container with arbitrary opts" do
      let :parent do
        described_class.new foo: 'bar'
      end

      subject do
        described_class.new parent, iphone: 'rox'
      end

      it "combines args with parent args" do
        subject.args.should == { foo: 'bar', iphone: 'rox' }
      end
    end
  end

  context "within a parent container with arbitrary opts" do
    let :parent do
      described_class.new foo: 'bar'
    end

    subject do
      described_class.new parent
    end

    it "makes parent opts available as args" do
      subject.args.should == { foo: 'bar' }
    end
  end

  context "with a motive" do
    let :motive do
      Motivation::Motive.new motive_opt: 'mo modules mo opts' do
        def motive_method
          'mo modules mo methods'
        end
      end
    end

    subject do
      described_class.new motives: [motive]
    end

    it "includes its opt" do
      subject.motive_opt.should == 'mo modules mo opts'
    end

    it "includes its methods" do
      subject.motive_method.should == 'mo modules mo methods'
    end

    it "passes on its motives" do
      subject.container!('my_sub_container')
      subject.container('my_sub_container').motives.should == [motive]
    end
  end

  describe "declaring a sub-container" do
    it "makes a new container" do
      subject.container!('my_sub_container').should == Motivation::Container.new(subject, name: 'my_sub_container')
    end

    it "makes this container its parent" do
      subject.container!('my_sub_container').parent.should == subject
    end

    it "stores the sub-container" do
      subject.container!('my_sub_container')
      subject.containers.should == [Motivation::Container.new(subject, name: 'my_sub_container')]
    end

    it "makes the sub-container available by name" do
      subject.container!('my_sub_container')
      subject.container('my_sub_container').should == Motivation::Container.new(subject, name: 'my_sub_container')
    end
  end

  describe "declaring a mote" do
    it "makes a new mote" do
      subject.mote!('my_mote').should == Motivation::Mote.new(subject, name: 'my_mote')
    end

    it "makes this container its parent" do
      subject.mote!('my_mote').parent.should == subject
    end

    it "stores the mote" do
      subject.mote! 'my_mote'
      subject.motes.should == [Motivation::Mote.new(subject, name: 'my_mote')]
    end
  end
end
