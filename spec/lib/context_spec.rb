require 'spec_helper'

describe Context do
  subject do
    Context.new motivator, definition
  end

  let :my_mote do
    Object.new.tap do |object|
    end
  end

  let :my_mote_definition do
    Object.new.tap do |object|
      stub(object).name { :my_mote }
      stub(object).motives { [] }
    end
  end

  let :motivator do
    Object.new.tap do |object|
      stub(object).resolve_mote_definition(anything, my_mote_definition) { my_mote }
    end
  end

  let :definition do
    Object.new.tap do |object|
      stub(object).motes { [my_mote_definition] }
    end
  end

  describe "[mote_name]" do
    it "resolves a mote" do
      expect(subject[:my_mote]).to eq(my_mote)
    end

    it "resolves the same mote" do
      expect(subject[:my_mote]).to eq(my_mote)
      dont_allow(motivator).resolve_mote_definition
      expect(subject[:my_mote]).to eq(my_mote)
    end
  end
end
