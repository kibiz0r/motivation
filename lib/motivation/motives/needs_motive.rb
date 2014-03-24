module Motivation
  module Motives
    class NeedsMotive < Motive
      def initialize(parent, *needs)
        super parent
        @needs = needs
      end

      def resolve_self(mote)
        @needs.map &:resolve
      end

      def resolve_new_motive(mote, new_motive)
        new_motive.resolve_self mote, *resolve_self(mote)
      end
    end
  end
end
