require "spec_helper"

describe NewMotive do
  test_module :my_module do |mod|
    mod::MyClass = Class.new
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
    test_module :my_module do |mod|
      mod::MyNamespace = Module.new.tap do |namespace|
        namespace::MyClass = Class.new
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
        expect(subject.namespace).to eq(my_module::MyNamespace)
        expect(subject.constant).to eq(my_module::MyNamespace::MyClass)
        expect(subject.new).to be_a_kind_of(my_module::MyNamespace::MyClass)
      end
    end
  end
end
