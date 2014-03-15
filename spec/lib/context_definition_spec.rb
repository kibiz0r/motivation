require "spec_helper"

# context do
#   my_mote!
#   foo_motive do
#     foo_mote!
#   end
#   bar_motive baz_mote do
#     bar_mote!
#   end
#   foo_mote!.foo_motive
#   foo_motive.foo_mote!
#   one_mote! do
#     two_mote!
#   end
# end
describe ContextDefinition do
  subject do
    ContextDefinition.new motivator
  end

  let :context_definition do
    subject
  end

  context "without any motives" do
    let :motivator do
      Object.new.tap do |object|
        stub(object).has_motive? { false }
      end
    end

    it "creates mote definitions" do
      subject.my_mote!
      expect(subject.motes).to eq([mote_definition(:my_mote)])
    end

    it "returns mote references" do
      expect(subject.my_mote).to eq(mote_reference(:my_mote))
    end

    it "lets you nest motes" do
      subject.eval do
        one_mote! do
          two_mote!
        end
      end
      expect(subject.motes).to eq([mote_definition(:one_mote), mote_definition(:two_mote)])
    end
  end

  context "with motives" do
    let :motivator do
      Object.new.tap do |object|
        stub(object).has_motive? { false }
        stub(object).has_motive?("foo_motive") { true }
        stub(object).has_motive?("bar_motive") { true }
        stub(object).has_motive?("baz_motive") { true }
      end
    end

    it "creates motive references" do
      motive = subject.foo_motive
      expect(motive).to eq(motive_reference(:foo_motive))
    end

    it "executes blocks on motive references" do
      subject.eval do
        foo_motive do
          foo_mote!
        end
      end
      expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:foo_motive))])
    end

    it "applies motive references inside motive blocks" do
      subject.eval do
        foo_motive do
          foo_mote! bar_motive
        end
      end
      expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:bar_motive), motive_reference(:foo_motive))])
    end

    it "applies arguments to motive references" do
      subject.eval do
        bar_motive baz_mote do
          bar_mote!
        end
      end
      expect(subject.motes).to eq([mote_definition(:bar_mote, motive_reference(:bar_motive, mote_reference(:baz_mote)))])
    end

    it "lets you say foo_motive.foo_mote!" do
      subject.eval do
        foo_motive(5).foo_mote!
      end
      expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:foo_motive, 5))])
    end

    it "lets you say foo_mote!.foo_motive" do
      subject.eval do
        foo_mote!.foo_motive
      end
      expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:foo_motive))])
    end

    it "lets you say foo_mote!.foo_motive 5" do
      subject.eval do
        foo_mote!.foo_motive 5
      end
      expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:foo_motive, 5))])
    end

    it "lets you say foo_mote!.foo_motive.bar_motive" do
      subject.eval do
        foo_mote!.foo_motive(1).bar_motive(2)
      end
      expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:foo_motive, 1), motive_reference(:bar_motive, 2))])
    end
  end
end