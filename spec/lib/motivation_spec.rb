require 'spec_helper'

describe Motivation do
  before :all do
    Motivation.reset!
  end

  after do
    Motivation.reset!
  end

  context "with a context" do
    let :context do
      Object.new
    end

    before do
      Motivation::Context.current = context
    end

    describe "#foo" do
      it "locates foo in the current context" do
        stub(context).locate_mote('foo', 'arg1', opt: 'val') { :located }
        subject.foo('arg1', opt: 'val').should == :located
      end
    end

    describe "#foo!" do
      let :context do
        Object.new
      end

      before do
        Motivation::Context.current = context
      end

      it "resolves foo in the current context" do
        stub(context).resolve_mote!('foo', 'arg1', opt: 'val') { :resolved }
        subject.foo!('arg1', opt: 'val').should == :resolved
      end
    end
  end

  describe "#context!" do
    context "with motives" do
      let :motive1 do
        Module.new
      end

      let :motive2 do
        Module.new
      end

      before do
        Motivation.motives << motive1
        Motivation.motives << motive2
      end

      it "passes on defined motives" do
        subject.context!.motives.should == [motive1, motive2]
      end
    end
  end

  describe "#files" do
    let :context do
      Object.new
    end

    before do
      Motivation::Context.current = context
    end

    it "delegates to the current context" do
      stub(context).files { :files }
      subject.files.should == :files
    end
  end

  describe "#file_dependencies" do
    let :context do
      Object.new
    end

    before do
      Motivation::Context.current = context
    end

    it "delegates to the current context" do
      stub(context).file_dependencies { :file_dependencies }
      subject.file_dependencies.should == :file_dependencies
    end
  end
end
