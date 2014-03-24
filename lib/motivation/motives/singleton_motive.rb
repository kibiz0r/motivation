module Motivation
  module Motives
    class SingletonMotive < Motive
      def initialize(motive_instance, is_singleton)
        super motive_instance
        @is_singleton = is_singleton
      end

      def is_singleton?
        !!@is_singleton
      end
    end
  end
end
