require 'spec_helper'

describe Motivation::MoteLoader do
  let :container do
    Object.new
  end

  subject do
    described_class.new container
  end

  describe "#motivation" do
    it "delegates to the container" do
      mock(container).motivation 'foo', bar: 'baz'
      subject.motivation 'foo', bar: 'baz'
    end
  end

  describe "#method_missing" do
    context "with a block" do
      it "creates a container" do
        mock(container).container! :foo, 'wat', bar: 'baz'
        subject.foo 'wat', bar: 'baz' do
        end
      end
    end

    context "without a block" do
      it "creates a mote" do
        mock(container).mote! :foo, 'wat', bar: 'baz'
        subject.foo 'wat', bar: 'baz'
      end
    end
  end
end
