require "spec_helper"

describe NeedsMotive do
  let :my_module do
    MyModule = Module.new.tap do |mod|
      mod::MyDep = Class.new
      mod::MyClass = Class.new do
        attr_reader :dep

        def initialize(dep)
          @dep = dep
        end
      end
    end
  end

  let :context do
    Motivator.new(Motivation, NeedsMotive, NewMotive, ConstantMotive, NamespaceMotive, my_module).eval do
      dependency_mote!.constant("MyDep").new
      my_mote!.constant("MyClass").new.needs(dependency_mote)
    end
  end

  subject do
    context[:my_mote]
  end

  describe "#new" do
    it "instantiates the mote with dependencies" do
      expect(my_module::MyDep.new).to be_a_kind_of(my_module::MyDep)
      expect(subject.new.dep).to be_a_kind_of(my_module::MyDep)
    end
  end

  # context "with namespaces" do
  #   let :my_module do
  #     Module.new.tap do |mod|
  #       mod::MyNamespace = Module.new.tap do |namespace|
  #         namespace::MyClass = Class.new
  #       end
  #     end
  #   end

  #   describe "#new" do
  #     it "instantiates the mote" do
  #       expect(subject.new).to be_a_kind_of(my_module::MyClass)
  #     end
  #   end
  # end
end
