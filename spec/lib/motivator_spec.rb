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
      awesome_motive = motive_reference(:awesome)
      my_mote = mote_definition(:my_mote, awesome_motive)
      awesome_motive.instance_variable_set :@parent, my_mote
      expect(context[:my_mote]).to eq(Mote.new(context, my_mote))
    end
  end
end
