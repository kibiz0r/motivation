module Motivation
  module Motives
    class NeedsMotive < Motive
      def initialize(parent, *needs)
        super parent
        @needs = needs
      end

      def resolve_self(mote)
        @needs.map do |mote_reference|
          needed_mote = mote.resolve_mote_reference mote_reference
          needed_mote.resolve
        end
      end

      def resolve_new_motive(mote, new_motive)
        new_motive.resolve_self mote, *resolve_self(mote)
      end
    end
  end
end
