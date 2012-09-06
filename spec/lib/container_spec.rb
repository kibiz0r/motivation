require 'spec_helper'

describe Motivation::Container do
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
      subject.opt(:motive_opt).should == 'mo modules mo opts'
    end

    it "includes its methods" do
      subject.motive_method.should == 'mo modules mo methods'
    end

    it "passes on its motives" do
      subject.container!('my_sub_container').motives.should == [motive]
    end
  end

  describe "declaring a sub-container" do
    it "makes a new container" do
      subject.container!('my_sub_container').should == Motivation::Container.new(name: 'my_sub_container', parent: subject)
    end

    it "makes this container its parent" do
      subject.container!('my_sub_container').parent.should == subject
    end

    it "stores the sub-container" do
      subject.container!('my_sub_container')
      subject.containers.should == [Motivation::Container.new(name: 'my_sub_container', parent: subject)]
    end

    it "makes the sub-container available by name" do
      subject.container!('my_sub_container')
      subject.container('my_sub_container').should == Motivation::Container.new(name: 'my_sub_container', parent: subject)
    end
  end

  describe "declaring a mote" do
    it "makes a new mote" do
      subject.mote!('my_mote').should == Motivation::Mote.new(name: 'my_mote', parent: subject)
    end

    it "makes this container its parent" do
      subject.mote!('my_mote').parent.should == subject
    end

    it "stores the mote" do
      subject.mote! 'my_mote'
      subject.motes.should == { my_mote: Motivation::Mote.new(name: 'my_mote', parent: subject) }
    end
  end
end
