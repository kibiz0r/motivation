require "spec_helper"

describe ConstantMotive do
  let :my_module do
    Module.new.tap do |mod|
      mod::MyClass = Class.new
    end
  end

  let :context do
    Motivator.new(Motivation, ConstantMotive, my_module).eval do
      my_mote!.constant("MyClass")
    end
  end

  subject do
    context[:my_mote]
  end

  it "does stuff" do
    expect(subject.constant).to eq(my_module::MyClass)
  end
end
