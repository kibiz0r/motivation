module Motivation
  module Motives
    class NewMotive < Motive
      def initialize(motive_instance, *args)
        super motive_instance
      end

      def resolve_self(mote, *args)
        mote.constant.new *(self.args + args)
      end

      def resolve_mote(mote, *args)
        mote.resolve_motive self, *args
      end
    end
  end
end
