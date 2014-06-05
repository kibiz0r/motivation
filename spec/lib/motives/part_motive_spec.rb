require "spec_helper"

describe PartMotive do
  context "when stacking two parts" do
    let :context do
      Motefile.eval do
        motivation :namespace, :part

        namespace_part "Foo" do
          namespace_part "Bar" do
            my_mote!
          end
        end
      end
    end

    it "passes them in as an array" do
      namespace_motive = context[:my_mote][:namespace]
      expect(namespace_motive).to eq(NamespaceMotive.new(["Foo", "Bar"]))
    end
  end

  context "when using inside non-part motive" do
    let :context do
      Motefile.eval do
        motivation :namespace, :part

        namespace "Foo" do
          namespace_part "Bar" do
            my_mote!
          end
        end
      end
    end

    it "stacks up" do
      namespace = context[:my_mote][:namespace].namespace
      expect(namespace).to eq("Foo::Bar")
    end
  end

  # This implies that NamespaceMotive shouldn't stack on its own,
  # because in this spec it is used to sort of "reset" the stack.
  #
  # So:
  #   namespace "Foo" do
  #     namespace "Bar" do
  #       # Motes in here are only scoped by "Bar", not "Foo::Bar"
  #     end
  #
  #     namespace_part "Bar" do
  #       # But Motes in here are scoped by "Foo::Bar"
  #     end
  #   end
  context "when using outside non-part motive" do
    let :context do
      Motefile.eval do
        motivation :namespace, :part

        namespace_part "Foo" do
          namespace "Bar" do
            my_mote!
          end
        end
      end
    end

    it "has no effect" do
      namespace = context[:my_mote][:namespace].namespace
      expect(namespace).to eq("Bar")
    end
  end

  context "when combining with pattern" do
    let :context do
      Motefile.eval do
        motivation :namespace, :part, :pattern

        namespace_pattern_part ->(m) { m.classify } do
          namespace_pattern_part ->(m) { "Whatever" } do
            my_mote!
          end
        end
      end
    end

    let :equivalent_context do
      Motefile.eval do
        motivation :namespace, :part, :pattern

        part :pattern, :namespace, ->(m) { m.classify } do
          part :pattern, :namespace, ->(m) { "Whatever" } do
            my_mote!
          end
        end
      end
    end

    it "combines the results of two patterns" do
      namespace = context[:my_mote][:namespace].namespace
      expect(namespace).to eq("MyMote::Whatever")
    end
  end
end
