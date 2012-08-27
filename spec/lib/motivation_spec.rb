require 'spec_helper'

describe Motivation do
  describe "#require" do
    it "processes a Motefile" do
      Motivation.require 'spec/data/Foofile'
      Motivation.foo.should == Foo
    end

    it "establishes namespaces" do
      Motivation.require 'spec/data/Motefile'
      Motivation.namespaces.map(&:to_hash).should == [
        {
          name: 'parts',
          strict: true,
          path: 'spec/data/parts'
        }
      ]
    end

    it "establishes motes" do
      Motivation.require 'spec/data/Motefile'
      Motivation.motes.map(&:to_hash).should =~ [
        {
          name: 'robot',
          path: 'spec/data/robot.rb',
          dependencies: [:left_leg, :right_leg]
        },
        {
          name: 'leg',
          path: 'spec/data/parts/leg.rb',
          dependencies: [:foot]
        },
        {
          name: 'left_leg',
          path: 'spec/data/parts/leg.rb',
          dependencies: [:foot]
        },
        {
          name: 'right_leg',
          path: 'spec/data/parts/leg.rb',
          dependencies: [:foot]
        },
        {
          name: 'foot',
          path: 'spec/data/parts/foot.rb',
          dependencies: []
        },
        {
          name: 'left_foot',
          path: 'spec/data/parts/foot.rb',
          dependencies: []
        },
        {
          name: 'right_foot',
          path: 'spec/data/parts/foot.rb',
          dependencies: []
        },
      ]
    end
  end
end
