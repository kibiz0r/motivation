module Motivation
  module Motives
    class ValueMotive < Motive
      attr_reader :value

      def initialize(motive_instance, value)
        super motive_instance
        @value = value
      end

      def resolve_mote(mote)
        @value
      end
    end
  end
end
