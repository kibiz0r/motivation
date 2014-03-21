require "spec_helper"

describe NamespaceMotive do
  let_module :my_module do |mod|
    mod::MyClass = "wrong class"
    mod::MyNamespace = "wrong namespace"
    mod::TopNamespace = Module.new.tap do |top|
      top::MyClass = "wrong class"
      top::MyNamespace = "wrong namespace"
      top::MiddleNamespace = Module.new.tap do |middle|
        middle::MyClass = "wrong class"
        middle::MyNamespace = Module.new.tap do |namespace|
          namespace::MyClass = Class.new
        end
      end
    end
  end

  let :motivator do
    Motivator.new Mote.define(Motive.instance(:context)), Motivation, NamespaceMotive, my_module
  end

  subject do
    motivator.eval do
      parent_mote!.namespace "TopNamespace" do
        namespace "MiddleNamespace" do
          my_mote!.namespace "MyNamespace"
        end
      end
    end
  end

  let :parent_mote do
    subject[:parent_mote]
  end

  let :my_mote do
    subject[:my_mote]
  end

  it "makes a namespace motive" do
    expect(parent_mote[:namespace]).to eq(
      NamespaceMotive.new(
        Motive.instance(
          Mote.define(
            motivator.root_mote.definition,
            :parent_mote,
            Motive.instance(
              :namespace,
              "TopNamespace"
            )
          ),
          :namespace,
          "TopNamespace"
        ),
        "TopNamespace"
      )
    )
    expect(my_mote[:namespace]).to eq(
      NamespaceMotive.new(
        Motive.instance(
          Mote.define(
            Mote.define(
              motivator.root_mote.definition,
              :parent_mote,
              Motive.instance(
                :namespace,
                "TopNamespace"
              )
            ),
            :my_mote,
            Motive.instance(
              :namespace,
              "MiddleNamespace"
            )
          ),
          :namespace,
          "MyNamespace"
        ),
        "MyNamespace"
      )
    )
  end

  it "resolves a namespace" do
    expect(my_mote.namespace).to eq(my_module::TopNamespace::MiddleNamespace::MyNamespace)
  end

  # it "makes a namespace motive" do
  #   expect(subject[:namespace]).to eq(NamespaceMotive.new(subject, "MyNamespace"))
  # end

  # it "resolves a namespace" do
  #   expect(subject.namespace).to eq(my_module::MyNamespace)
  #   expect(subject.namespace).to eq(NamespaceMotive.new(subject, "MyNamespace").resolve)
  #   expect(subject[:namespace].resolve).to eq(subject.namespace)
  #   expect(subject.resolve).to eq(subject.namespace)
  # end

  # context "with a named motive" do
  #   let :context do
  #     Motivator.new(Motivation, NamespaceMotive, my_module).eval do
  #       my_mote! my_motive: namespace("MyNamespace")
  #     end
  #   end

  #   it "resolves a namespace" do
  #     expect(subject.my_motive).to eq(my_module::MyNamespace)
  #     expect(subject.my_motive).to eq(NamespaceMotive.new(subject, "MyNamespace").resolve)
  #     expect(subject[:my_motive].resolve).to eq(subject.my_motive)
  #     expect(subject.resolve).to eq(subject.my_motive)
  #   end
  # end

  # context "with a constant" do
  #   let :context do
  #     Motivator.new(Motivation, ConstantMotive, NamespaceMotive, my_module).eval do
  #       my_mote!.namespace("MyNamespace").constant("MyClass")
  #     end
  #   end

  #   it "resolves a constant" do
  #     expect(context[:my_mote][:constant].parent).to eq(context[:my_mote])
  #     expect(context[:my_mote][:constant]).to eq(ConstantMotive.new(context[:my_mote], "MyNamespace::MyClass"))
  #     expect(context[:my_mote][:constant].resolve).to eq(my_module::MyNamespace::MyClass)
  #     expect(subject.constant).to eq(my_module::MyNamespace::MyClass)
  #   end
  # end

  # context "with multiple namespaces" do
  #   test_module :my_module do |mod|
  #     mod::MyNamespace = Module.new
  #     mod::ParentNamespace = Module.new.tap do |parent|
  #       parent::MyNamespace = Module.new.tap do |namespace|
  #         namespace::MyClass = Class.new
  #       end
  #     end
  #   end

  #   let :context do
  #     Motivator.new(Motivation, NamespaceMotive, my_module).eval do
  #       parent_mote!.namespace "ParentNamespace" do
  #         my_mote!.namespace "MyNamespace"
  #       end
  #     end
  #   end

  #   it "resolves multiple namespaces" do
  #     # expect(context[:parent_mote][:namespace].resolve).to eq(my_module::ParentNamespace)

  #     # FAILZ
  #     # The motive's resolution parent is only another namespace motive in this case because it happens to be the only motive in the parent
  #     # In these cases, its resolution parent would be the constant motive, which can't resolve a namespace anyway
  #     # parent_mote!.namespace("ParentNamespace").constant("MyClass") do
  #     # parent_mote! namespace("ParentNamespace"), constant("MyClass") do
  #     #   my_mote!.namespace "MyNamespace"
  #     # end
  #     #
  #     # Mote(:my_mote).namespace =>
  #     # Mote(:my_mote).motive(:namespace).resolve (which is NamespaceMotive("MyNamespace").resolve) =>
  #     # MotiveResolver.resolve_motive(NamespaceMotive("MyNamespace")) =>
  #     # NamespaceMotive("ParentNamespace").resolve_namespace_motive(NamespaceMotive("MyNamespace")) =>
  #     # Motivator.resolve_namespace_motive(NamespaceMotive("ParentNamespace"))
  #     #
  #     # Mote.constant =>
  #     # find a resolve_constant starting with the right-most Motive or check parent motives =>
  #     # find a resolve_constant_motive on the soonest parent (Motive or Mote) of the one you wanted to call resolve_constant on =>
  #     #
  #     # Mote.namespace
  #     # find a resolve_namespace starting with the right-most Motive or check parent motives =>
  #     # find a resolve_namespace_motive on the nearest parent (Motive or Mote) of the one you wanted to call resolve_namespace on =>
  #     # repeat until you reach the top, where you call resolve_namespace_motive on the top responding motive you found
  #     #
  #     # resolve_<type>_<motive> on the motive (or mote?) you would call => 
  #     #
  #     # resolve_constant => resolve_constant_motive => resolve_constant_motive_reference
  #     # Mote(:my_mote).constant =>
  #     # Mote(:my_mote).motive(:constant).resolve (which is ConstantMotive("MyClass").resolve) =>
  #     # MotiveResolver.resolve_motive(ConstantMotive("MyClass")) =>
  #     # ConstantMotive.resolve_constant_motive(ConstantMotive("MyClass"))
  #     # ConstantMotive("MyClass").resolve_constant
  #     # ConstantMotive("MyClass").resolve_constant
  #     #
  #     # parent_mote!.namespace("ParentNamespace").constant("ParentClass").needs(foo_mote).new do
  #     #   my_mote!.namespace("MyNamespace").constant("MyClass").needs(bar_mote).new
  #     # end
  #     #
  #     # context[:my_mote].resolve =>
  #     # Mote(:my_mote).resolve =>
  #     # Mote(:my_mote).motive(:new).resolve =>
  #     # NewMotive().resolve =>
  #     # MotiveResolver.resolve_motive(NewMotive()) => # finds NewMotive().resolve_self, then finds NeedsMotive().resolve_new_motive and prefers that
  #     #
  #     # NeedsMotive().resolve_new_motive(NewMotive()) => 
  #     # NewMotive().resolve_self(NeedsMotive(bar_mote).resolve_self) => # saying NewMotive().resolve would start an infinite loop
  #     #
  #     # ConstantMotive("MyClass").resolve.new(bar) =>
  #     # MotiveResolver.resolve_motive(ConstantMotive("MyClass")) => # finds ConstantMotive("MyClass").resolve_self, then finds NamespaceMotive("MyNamespace").resolve_constant_motive and prefers that
  #     #
  #     # NamespaceMotive("MyNamespace").resolve_constant_motive(ConstantMotive("MyClass")) =>
  #     # NamespaceMotive("MyNamespace").resolve.const_get(ConstantMotive("MyClass").constant) =>
  #     # MotiveResolver.resolve_motive(NamespaceMotive("MyNamespace")) => # finds NamespaceMotive("MyNamespace").resolve_self, then finds NamespaceMotive("ParentNamespace").resolve_namespace_motive and prefers that
  #     #
  #     # NamespaceMotive("ParentNamespace").resolve_namespace_motive(NamespaceMotive("MyNamespace")) =>
  #     # NamespaceMotive("ParentNamespace").resolve.const_get((NamespaceMotive("MyNamespace").namespace) =>
  #     # MotiveResolver.resolve_motive(NamespaceMotive("ParentNamespace")) => # only finds NamespaceMotive("ParentNamespace").resolve_self, or does it find MotiveResolver.resolve_namespace_motive and ignores it because it == self?
  #     #
  #     # NamespaceMotive("ParentNamespace").resolve_self =>
  #     # Object.const_get(NamespaceMotive("ParentNamespace").namespace)
  #     #
  #     # If MotiveResolver.resolve_motive(FooMotive) can == MotiveResolver.resolve_foo_motive, then Motives can be MotiveResolvers themselves
  #     # Should Motes be MoteResolvers then? I guess they already are. Normal Motes just call resolve_self on their children to resolve them -- Motives can resolve child Motes, but I can't think of a use case
  #     # I don't think there's any formal type that a resolver has to be, just implementing resolve_<thing> and being in the graph should be enough
  #     # Contexts stop resolution from bubbling up outside of them because they can resolve everything inside of them, but nothing outside of them can resolve a context except another context
  #     expect(context[:my_mote].parent).to eq(context[:parent_mote])
  #     expect(context[:my_mote][:namespace].resolve).to eq(my_module::ParentNamespace::MyNamespace)
  #     expect(subject.namespace).to eq(my_module::ParentNamespace::MyNamespace)
  #   end
  # end
end
