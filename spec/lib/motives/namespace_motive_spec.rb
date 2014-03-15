require "spec_helper"

describe NamespaceMotive do
  let :my_module do
    Module.new.tap do |mod|
      mod::MyNamespace = Module.new.tap do |namespace|
        namespace::MyClass = Class.new
      end
    end
  end

  let :context do
    Motivator.new(Motivation, ConstantMotive, NamespaceMotive, my_module).eval do
      my_mote!.namespace("MyNamespace").constant("MyClass")
    end
  end

  subject do
    context[:my_mote]
  end

  it "does stuff" do
    expect(subject.constant).to eq(my_module::MyNamespace::MyClass)
  end
end
