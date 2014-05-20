module Motivation
  module Motives
    class ContextMotive < Motive
      def initialize(mote)
        super mote
        @mote_definitions = {}
      end

      def find_mote_definition(mote, mote_definition_name)
        @mote_definitions[mote_definition_name.to_sym]
      end

      def add_mote_definition(mote, mote_definition)
        @mote_definitions[mote_definition.name.to_sym] = mote_definition
      end

      def resolve_mote_definition(mote, mote_definition)
        Mote.new mote.resolve_mote_definition(mote_definition.parent), mote_definition
      end

      def propose_resolution(resolution)
      end
    end
  end
end
