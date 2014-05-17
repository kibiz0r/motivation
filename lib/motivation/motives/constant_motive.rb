module Motivation
  module Motives
    class ConstantMotive < Motive
      def initialize(motive_instance, constant = nil)
        super motive_instance
        @constant = constant
      end

      def constant(mote)
        @constant || mote.name.to_s.camelize
      end

      def resolve_self(mote, *args)
        mote.require_source_const constant(mote)
      end

      # def resolve(resolution)
      def handle_resolution(resolution)
        resolution.for self do
        end

        resolution.for Mote do |mote|
        end

        resolution.for MoteDefinition do
        end
      end
    end
  end
end
