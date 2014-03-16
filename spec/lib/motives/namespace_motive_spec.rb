require "spec_helper"

describe NamespaceMotive do
  test_module :my_module do |mod|
    mod::MyNamespace = Module.new.tap do |namespace|
      namespace::MyClass = Class.new
    end
  end

  let :context do
    Motivator.new(Motivation, NamespaceMotive, my_module).eval do
      my_mote!.namespace("MyNamespace")
    end
  end

  subject do
    context[:my_mote]
  end

  it "resolves a namespace" do
    expect(subject.namespace).to eq(my_module::MyNamespace)
  end

  context "with a constant" do
    let :context do
      Motivator.new(Motivation, ConstantMotive, NamespaceMotive, my_module).eval do
        my_mote!.namespace("MyNamespace").constant("MyClass")
      end
    end

    it "resolves a constant" do
      expect(subject.constant).to eq(my_module::MyNamespace::MyClass)
    end
  end

  context "with multiple namespaces" do
    test_module :my_module do |mod|
      mod::ParentNamespace = Module.new.tap do |parent|
        parent::MyNamespace = Module.new.tap do |namespace|
          namespace::MyClass = Class.new
        end
      end
    end

    let :context do
      Motivator.new(Motivation, NamespaceMotive, my_module).eval do
        namespace "ParentNamespace" do
          my_mote!.namespace "MyNamespace"
        end
      end
    end

    it "resolves multiple namespaces" do
      expect(subject.namespace).to eq(my_module::ParentNamespace::MyNamespace)
    end
  end
end
