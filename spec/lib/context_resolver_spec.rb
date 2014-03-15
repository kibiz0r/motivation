require "spec_helper"

describe ContextResolver do
  subject do
    ContextResolver.new
  end

  let :motivator do
    Object.new.tap do |object|
    end
  end

  let :context_definition do
    Object.new.tap do |object|
    end
  end

  it "returns a context" do
    context = subject.resolve_definition motivator, context_definition
    expect(context).to be_a_kind_of(Context)
  end

  # context "with a motive" do
  #   let :motes do
  #     [
  #       mote_definition(:my_mote, motive_reference(:class, "MyMote"))
  #     ]
  #   end

  #   before do
  #     stub(motivator).resolve_motive(:class, "MyMote")
  #   end

  #   it "resolves motives" do
  #     context = subject.resolve context_definition
  #     expect(context.motes).to eq([mote!(:my_mote, )])
  #   end
  # end
end
