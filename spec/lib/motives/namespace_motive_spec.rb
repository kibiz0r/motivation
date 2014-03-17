require "spec_helper"

describe NamespaceMotive do
  test_module :my_module do |mod|
    mod::MyClass = Class.new
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

  it "makes a namespace motive" do
    expect(subject[:namespace]).to eq(NamespaceMotive.new(subject, "MyNamespace"))
  end

  it "resolves a namespace" do
    expect(subject.namespace).to eq(my_module::MyNamespace)
    expect(subject.namespace).to eq(NamespaceMotive.new(subject, "MyNamespace").resolve)
    expect(subject[:namespace].resolve).to eq(subject.namespace)
    expect(subject.resolve).to eq(subject.namespace)
  end

  context "with a named motive" do
    let :context do
      Motivator.new(Motivation, NamespaceMotive, my_module).eval do
        my_mote! my_motive: namespace("MyNamespace")
      end
    end

    it "resolves a namespace" do
      expect(subject.my_motive).to eq(my_module::MyNamespace)
      expect(subject.my_motive).to eq(NamespaceMotive.new(subject, "MyNamespace").resolve)
      expect(subject[:my_motive].resolve).to eq(subject.my_motive)
      expect(subject.resolve).to eq(subject.my_motive)
    end
  end

  context "with a constant" do
    let :context do
      Motivator.new(Motivation, ConstantMotive, NamespaceMotive, my_module).eval do
        my_mote!.namespace("MyNamespace").constant("MyClass")
      end
    end

    it "resolves a constant" do
      expect(context[:my_mote][:constant].parent).to eq(context[:my_mote])
      expect(context[:my_mote][:constant]).to eq(ConstantMotive.new(context[:my_mote], "MyNamespace::MyClass"))
      expect(context[:my_mote][:constant].resolve).to eq(my_module::MyNamespace::MyClass)
      expect(subject.constant).to eq(my_module::MyNamespace::MyClass)
    end
  end

  context "with multiple namespaces" do
    test_module :my_module do |mod|
      mod::MyNamespace = Module.new
      mod::ParentNamespace = Module.new.tap do |parent|
        parent::MyNamespace = Module.new.tap do |namespace|
          namespace::MyClass = Class.new
        end
      end
    end

    let :context do
      Motivator.new(Motivation, NamespaceMotive, my_module).eval do
        parent_mote!.namespace "ParentNamespace" do
          my_mote!.namespace "MyNamespace"
        end
      end
    end

    it "resolves multiple namespaces" do
      expect(context[:parent_mote][:namespace].resolve).to eq(my_module::ParentNamespace)

      # FAILZ
      expect(context[:my_mote].parent).to eq(context[:parent_mote])
      expect(context[:my_mote][:namespace].resolve).to eq(my_module::ParentNamespace::MyNamespace)
      expect(subject.namespace).to eq(my_module::ParentNamespace::MyNamespace)
    end
  end
end
