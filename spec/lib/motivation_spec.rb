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
      mock(context).resolve! :foo, 'arg1', opt: 'val'
      subject.foo 'arg1', opt: 'val'
    end
  end
end
