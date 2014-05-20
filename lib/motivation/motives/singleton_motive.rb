module Motivation
  module Motives
    class SingletonMotive < Motive
      def initialize(mote, is_singleton)
        super mote
        @is_singleton = is_singleton
      end

      def is_singleton?
        !!@is_singleton
      end
    end
  end
end
