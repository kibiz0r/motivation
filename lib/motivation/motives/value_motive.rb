module Motivation
  module Motives
    class ValueMotive < Motive
      attr_reader :value

      def initialize(motive_instance, value)
        super motive_instance
        @value = value
      end

      def resolve_mote(mote)
        resolve_self(mote)
      end

      def resolve_self(mote, *args)
        if value.is_a? Array
          resolved_elements = value.map do |element|
            element_mote = mote.resolve_mote_reference element
            element_mote.resolve
          end
        end
      end
    end
  end
end
