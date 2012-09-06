shared_examples_for "a mote container" do
  context "with a motive" do
    let :motive do
      Motivation::Motive.new
    end

    subject do
      described_class.new motives: [motive]
    end

    describe "#mote!" do
      it "passes on its motives" do
        subject.mote!.motives.should == [motive]
      end
    end
  end
end
