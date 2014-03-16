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

  it "resolves to a constant" do
    expect(subject.constant).to eq(my_module::MyClass)
  end

  context "as another name" do
    let :context do
      Motivator.new(Motivation, ConstantMotive, my_module).eval do
        my_mote! my_motive: constant("MyClass")
      end
    end

    it "still resolves to a constant" do
      expect(subject.my_motive).to eq(my_module::MyClass)
    end
  end
end
