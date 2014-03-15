require "spec_helper"

describe NewMotive do
  let :my_module do
    Module.new.tap do |mod|
      mod::MyClass = Class.new
    end
  end

  let :context do
    Motivator.new(Motivation, NewMotive, ConstantMotive, NamespaceMotive, my_module).eval do
      my_mote!.constant("MyClass").new
    end
  end

  subject do
    context[:my_mote]
  end

  describe "#new" do
    it "instantiates the mote" do
      expect(subject.new).to be_a_kind_of(my_module::MyClass)
    end
  end

  context "with namespaces" do
    let :my_module do
      Module.new.tap do |mod|
        mod::MyNamespace = Module.new.tap do |namespace|
          namespace::MyClass = Class.new
        end
      end
    end

    let :context do
      Motivator.new(Motivation, NewMotive, ConstantMotive, NamespaceMotive, my_module).eval do
        namespace "MyNamespace" do
          my_mote!.constant("MyClass").new
        end
      end
    end

    describe "#new" do
      it "instantiates the mote" do
        expect(subject.new).to be_a_kind_of(my_module::MyNamespace::MyClass)
      end
    end
  end
end
