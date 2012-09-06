require 'spec_helper'
require 'motivation/motives/opaque'

describe Motivation::Motives::Opaque do
  let :fallback do
    Motivation::Motive.new do
      def require!
        self.require
      end
    end
  end

  context "on a mote" do
    context "by default" do
      subject do
        Motivation::Mote.new name: 'implicit_constant',
          motives: [fallback, described_class]
      end

      it "still requires upon require!" do
        mock(subject).require
        subject.require!
      end
    end

    context "with opaque: false" do
      subject do
        Motivation::Mote.new name: 'implicit_constant',
          opaque: false,
          motives: [fallback, described_class]
      end

      it "still requires upon require!" do
        mock(subject).require
        subject.require!
      end
    end

    context "with opaque: true" do
      subject do
        Motivation::Mote.new name: 'implicit_constant',
          opaque: true,
          motives: [fallback, described_class]
      end

      it "doesn't require upon require!" do
        dont_allow(subject).require
        subject.require!
      end
    end
  end
end


