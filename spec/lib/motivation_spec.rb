require 'spec_helper'

describe Motivation do
  describe "#foo" do
    let :context do
      Object.new
    end

    before do
      Motivation::Context.current = context
    end

    it "delegates to the current context" do
      mock(context).resolve! :foo
      subject.foo
    end
  end
end
