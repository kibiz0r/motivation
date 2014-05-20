module Motivation
  module Motives
    class ConstantMotive < Motive
      def initialize(mote, constant = nil)
        super mote
        @constant = constant
      end

      def constant
        @constant || mote.name.to_s.camelize
      end

      def propose_resolution(resolution)
        resolution.for self do
          resolution.propose do
            mote.require_source_const constant
          end
        end

        resolution.for Mote do |mote|
        end

        resolution.for MoteDefinition do
        end
      end
    end
  end
end
