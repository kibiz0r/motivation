module Motivation
  module Motives
    class NewMotive < Motive
      attr_reader :args

      def initialize(mote, *args)
        super mote
        @args = args
      end

      def resolve_self(mote, *args)
        mote.constant.new *(self.args + args)
      end

      def resolve_mote(mote, *args)
        mote.resolve_motive self, *args
      end

      def propose_resolution(resolution, target, *args)
        if target == self
          resolution.propose do
            mote.constant.new *(self.args + args)
          end
        end

        if target == mote
          resolution.final do
            self.resolve *args
          end
        end

        # resolution.for self do |args|
        #   mote.constant.new *(self.args + args)
        # end

        # Should this be:
        # resolution.for mote
        # or
        # resolution.for Mote do |mote|
        #
        # Maybe this question is the key to differentiating Motives like:
        #
        # new("arg") do
        #   my_mote!
        #   another_mote!
        # end
        #
        # vs.
        #
        # my_mote!.new("arg")
        # another_mote!.new("arg")
        #
        # Because, if you later changed the NewMotive in the first case, you'd
        # want it to apply to both Motes, but in the second case the change
        # should only apply to the single Mote that the NewMotive is attached
        # to.
        #
        # So, if we tried to model that, the first NewMotive would have no
        # @mote; it would be nil.
        #
        # So, Motives have two modes: one where they are acting as scopes on
        # Motes, and one where they are attached to one Mote explicitly.
        #
        # Motives can still affect child Motes even if they are not acting like
        # a scope, but because they have a specific Mote reference in @mote,
        # they can decide not to act like a scope.
        # resolution.for mote do |_, args|
        #   resolution.propose do
        #     p self.args
        #     p args
        #     mote.constant.new *(self.args + args)
        #   end
        # end
      end
    end
  end
end
