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
        stub(object).motive_defined? { false }
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
      one_mote = mote_definition(:one_mote)
      two_mote = mote_definition(:two_mote)
      two_mote.instance_variable_set :@parent, one_mote
      expect(subject.motes).to eq([one_mote, two_mote])
    end
  end

  context "with motives" do
    let :motivator do
      Object.new.tap do |object|
        stub(object).motive_defined? { false }
        stub(object).motive_defined?("foo_motive") { true }
        stub(object).motive_defined?("bar_motive") { true }
        stub(object).motive_defined?("baz_motive") { true }
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
      # expect(subject.motes).to eq([mote_definition(:foo_mote, motive_reference(:foo_motive))])
      motive = motive_reference(:foo_motive)
      mote = mote_definition(:foo_mote)
      mote.instance_variable_set :@parent, motive
      expect(subject.motes).to eq([mote])
    end

    it "applies motive references inside motive blocks" do
      subject.eval do
        foo_motive do
          foo_mote! bar_motive
        end
      end
      foo_motive = motive_reference(:foo_motive)
      bar_motive = motive_reference(:bar_motive)
      bar_motive.instance_variable_set :@parent, motive_block(foo_motive)
      mote = mote_definition(:foo_mote, bar_motive)
      mote.instance_variable_set :@parent, foo_motive
      expect(subject.motes).to eq([mote])
    end

    it "applies arguments to motive references" do
      subject.eval do
        bar_motive baz_mote do
          bar_mote!
        end
      end
      motive = motive_reference(:bar_motive, mote_reference(:baz_mote))
      mote = mote_definition(:bar_mote)
      mote.instance_variable_set :@parent, motive
      expect(subject.motes).to eq([mote])
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
      foo_motive = motive_reference(:foo_motive)
      foo_mote = mote_definition(:foo_mote, foo_motive)
      foo_motive.instance_variable_set :@parent, foo_mote
      expect(subject.motes).to eq([foo_mote])
    end

    it "lets you say foo_mote!.foo_motive 5" do
      subject.eval do
        foo_mote!.foo_motive 5
      end
      foo_motive = motive_reference(:foo_motive, 5)
      foo_mote = mote_definition(:foo_mote, foo_motive)
      foo_motive.instance_variable_set :@parent, foo_mote
      expect(subject.motes).to eq([foo_mote])
    end

    it "lets you say foo_mote!.foo_motive.bar_motive" do
      subject.eval do
        foo_mote!.foo_motive(1).bar_motive(2)
      end
      foo_motive = motive_reference(:foo_motive, 1)
      bar_motive = motive_reference(:bar_motive, 2)
      foo_mote = mote_definition(:foo_mote, foo_motive, bar_motive)
      foo_motive.instance_variable_set :@parent, foo_mote
      bar_motive.instance_variable_set :@parent, foo_mote
      expect(subject.motes).to eq([foo_mote])
    end
  end
end
