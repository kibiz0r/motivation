module Motivation
  module Motives
    class NeedsMotive < Motive
      def initialize(mote, *needs)
        super mote
        @needs = needs
      end

      def resolve_self
        @needs.map do |mote_reference|
          needed_mote = mote.resolve_mote_reference mote_reference
          needed_mote.resolve
        end
      end

      def resolve_new_motive(mote, new_motive)
        new_motive.resolve_self mote, *resolve_self(mote)
      end

      def propose_resolution(resolution, target)
        if target == self
          resolution.propose do
            resolve_self
          end
        end

        if target == mote
          resolution.final do
            puts "resolving with needs"
            mote.new self.resolve
          end
        end
        # resolution.for self do
        #   resolution.propose do
        #     resolve_self
        #   end
        # end

        # puts "resolution for #{mote} vs #{resolution.target}"
        # resolution.for mote do |_, args|
        #   puts "resolving"
        #   resolution.final do
        #     puts "resolving with needs"
        #     mote.new self.resolve
        #   end
        # end

        # resolution.for NewMotive do |motive, args|
        #   resolution.preprocess do |proposal|
        #     proposal.args << self.resolve
        #   end
        # end
      end
    end
  end
end
