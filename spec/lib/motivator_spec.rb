require "spec_helper"

describe Motivator do
  let :motive_module do
    Module.new.tap do |mod|
      mod::AwesomeMotive = awesome_motive
    end
  end

  let :awesome_motive do
    Class.new Motive
  end

  subject do
    Motivator.new Motivation, motive_module
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
        mote_definition(:my_mote, motive_reference(:awesome)),
        awesome_motive.new
      )
      expect(context[:my_mote]).to eq(my_mote)
    end
  end
end
