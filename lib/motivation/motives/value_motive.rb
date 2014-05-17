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

      def handle_resolution(resolution)
        resolution.for Mote do |mote|
          resolution.return do
            resolve_node value # resolves a Mote, Array, or Hash
          end
        end
      end

      def self.handle_resolution(resolution)
        resolution.for :mote_defined => [Mote, Array, Hash] do |value|
          resolution.after do |definition|
            resolution.value.tap do |definition|
              definition.motives << Motive.instance(:value, value)
            end
          end
        end
      end
    end
  end
end
