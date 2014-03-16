require "spec_helper"

describe Motivator do
  test_module :my_module do |mod|
    mod::AwesomeMotive = Class.new
  end

  let :awesome_motive do
    my_module::AwesomeMotive
  end

  subject do
    Motivator.new Motivation, my_module
  end

  let :context_definition do
    context.definition
  end

  context "with a context" do
    let :context do
      subject.eval do
        my_mote!.awesome
      end
    end

    it "resolves a mote" do
      my_mote = Mote.new(
        context,
        mote_definition(:my_mote, motive_reference(:awesome))
      )
      expect(context[:my_mote]).to eq(my_mote)
    end
  end
end
