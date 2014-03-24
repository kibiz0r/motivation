require "spec_helper"

describe Mote do
  let :motive_instance1 do
    Motive.instance :motive1
  end

  let :motive_instance2 do
    Motive.instance :motive2
  end

  let :motive_instance3 do
    Motive.instance :motive3
  end

  let :parent do
    Motivator.new(nil, Module.new).tap do |object|
      stub(object).parent { nil }
      stub(object).motive_instance_finder { MotiveInstanceFinder.new }
      stub(object).mote_definition_finder { MoteDefinitionFinder.new }
      stub(object).mote_value_resolver { MoteValueResolver.new }
      stub(object).mote_reference_resolver { MoteReferenceResolver.new }
      stub(object).mote_definition_resolver { MoteDefinitionResolver.new }
    end
  end

  let :definition do
    Mote.define :my_mote, motive_instance1, motive_instance2, motive_instance3
  end

  subject do
    Mote.new parent, definition
  end

  describe "#motive_instances" do
    it "returns the instances in the definition" do
      expect(subject.motive_instances).to eq([motive_instance1, motive_instance2, motive_instance3])
    end
  end
  
  context "when defined with a value" do
    let :definition do
      Mote.define :my_mote, 5
    end

    describe "#resolve_value" do
      it "resolves to the definition's value" do
        expect(subject.resolve_value).to eq(5)
      end
    end
  end

  context "when defined with a template" do
    before do
      stub(parent).find_mote_definition(:template_mote) { template_definition }
      stub(parent).resolve_mote_definition(template_definition) { template_mote }
    end

    let :template_mote do
      Mote.new parent, template_definition
    end

    let :template_definition do
      Mote.define :template_mote, 8
    end

    let :template_reference do
      Mote.reference nil, :template_mote
    end

    let :definition do
      Mote.define :my_mote, template_reference
    end

    describe "#resolve_value" do
      it "resolves using the template's value" do
        expect(subject.resolve_value).to eq(8)
      end
    end
  end
end
