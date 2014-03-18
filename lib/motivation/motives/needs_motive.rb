module Motivation
  module Motives
    class NeedsMotive < Motive
      def initialize(parent, *needs)
        super parent, *needs
        @needs = needs
      end

      def resolve
        @needs.map do |need_reference|
          need_mote = self.parent.resolve_mote_reference need_reference
          need_mote.resolve
        end
      end

      def resolve_mote
        resolve_new_motive self.parent[:new]
      end

      def resolve_new_motive(new_motive)
        new_motive.resolve *self.resolve
      end
    end
  end
end
