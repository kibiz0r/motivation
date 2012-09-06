require 'spec_helper'

describe Motivation::Context do
  it_behaves_like "a mote container"

  describe "#locate_mote" do
    context "when the mote exists" do
      before { @foo = subject.mote! :foo }
      let(:foo) { @foo }

      it "returns the mote" do
        subject.locate_mote(:foo).should == foo
      end

      context "and there are arguments passed to locate_mote" do
        it "ignores the arguments" do
          subject.locate_mote(:foo, 'bar', whatever: 'stuff').should == foo
        end
      end
    end

    context "when the mote doesn't exist" do
      context "and there are no locators" do
        it "returns nil" do
          subject.locate_mote(:foo).should be_nil
        end
      end

      context "and there are locators" do
        let :locator1 do
          Object.new
        end

        let :locator2 do
          Object.new
        end

        let :locators do
          [locator1, locator2]
        end

        it "takes the first non-nil result from locators" do
          mock(locator1).locate(subject, :foo, 'arg1', opt: 'val') { nil }
          stub(locator2).locate(subject, :foo, 'arg1', opt: 'val') { :bar }
          subject.locators = locators
          subject.locate_mote(:foo, 'arg1', opt: 'val').should == :bar
        end
      end
    end
  end

  describe "#resolve_mote!" do
  end

  describe "#files" do
    let :motes do
      [
        Motivation::Mote.new,
        Motivation::Mote.new,
        Motivation::Mote.new,
        Motivation::Mote.new,
        Motivation::Mote.new
      ].tap do |motes|
        motes.each_with_index do |mote, index|
          stub(mote).name { "file_mote_#{index}" }
        end
      end
    end

    subject do
      described_class.new motes: motes
    end

    it "returns the files associated with the motes" do
      stub(motes[0]).file { 'foo.rb' }
      stub(motes[1]).file { 'bar.rb' }
      stub(motes[2]).file { nil }
      stub(motes[3]).file { 'baz.rb' }
      stub(motes[4]).file { nil }
      subject.files.should == ['foo.rb', 'bar.rb', 'baz.rb']
    end
  end

  describe "#file_dependencies" do
    let :motes do
      [
        Motivation::Mote.new,
        Motivation::Mote.new,
        Motivation::Mote.new,
        Motivation::Mote.new,
        Motivation::Mote.new
      ].tap do |motes|
        motes.each_with_index do |mote, index|
          stub(mote).name { "file_mote_#{index}" }
        end
      end
    end

    subject do
      described_class.new motes: motes
    end

    it "returns the files associated with the motes" do
      stub(motes[0]).file { 'foo.rb' }
      stub(motes[0]).required_mote_files { ['bar.rb'] }
      stub(motes[1]).file { 'bar.rb' }
      stub(motes[1]).required_mote_files { [] }
      stub(motes[2]).file { 'baz.rb' }
      stub(motes[2]).required_mote_files { ['foo.rb', 'bar.rb'] }
      stub(motes[3]).file { 'wtf.rb' }
      stub(motes[3]).required_mote_files { [] }
      stub(motes[4]).file { 'lol.rb' }
      stub(motes[4]).required_mote_files { ['foo.rb'] }
      subject.file_dependencies.should == {
        'foo.rb' => ['bar.rb'],
        'bar.rb' => [],
        'baz.rb' => ['foo.rb', 'bar.rb'],
        'wtf.rb' => [],
        'lol.rb' => ['foo.rb']
      }
    end
  end
end
