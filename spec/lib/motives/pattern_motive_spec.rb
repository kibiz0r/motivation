require "spec_helper"

describe PatternMotive do
  let :pattern_lambda do
    ->(m) { "My#{m.classify}" }
  end

  let :context do
    Motefile.eval do
      motivation :constant, :pattern

      constant_pattern pattern_lambda do
        awesome_mote!
        another_mote!.constant "AnotherMote"
      end
    end
  end

  context "when motives are being declared" do
    it "takes over ones that end in _pattern" do
      pattern_motive = context[:awesome_mote].parent
      expect(pattern_motive).to eq(PatternMotive.new(:constant, pattern_lambda))
    end
  end

  context "when motives are being accessed" do
    it "provides an instance of the patterned motive" do
      constant_motive = context[:awesome_mote][:constant]
      expect(constant_motive).to eq(ConstantMotive.new("MyAwesomeMote"))
    end

    it "defers to more specific motives" do
      constant_motive = context[:another_mote][:constant]
      expect(constant_motive).to eq(ConstantMotive.new("AnotherMote"))
    end
  end

  context "with less sugary syntax" do
    let :context do
      Motefile.eval do
        motivation :constant, :pattern

        pattern :constant, pattern_lambda do
          awesome_mote!
        end
      end
    end

    it "still works" do
      constant_motive = context[:awesome_mote][:constant]
      expect(constant_motive).to eq(ConstantMotive.new("MyAwesomeMote"))
    end
  end
end
