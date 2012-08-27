require 'spec_helper'

describe Motivation::Namespace do
  describe "#scan!" do
    subject do
      Motivation::Namespace.new path: 'spec/data/scan_me'
    end      

    it "scans its directory and creates motes for each found file" do
      subject.scan!.map(&:to_hash).should == [
        {
          name: 'one',
          path: 'spec/data/scan_me/one.rb',
          dependencies: []
        },
        {
          name: 'two',
          path: 'spec/data/scan_me/two.rb',
          dependencies: []
        },
      ]
    end
  end
end
