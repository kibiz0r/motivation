module Motivation
  module Motives
    class ContextMotive < Motive
      def initialize(motive_instance)
        @mote_definitions = {}
      end

      def find_mote_definition(mote, mote_definition_name)
        @mote_definitions[mote_definition_name.to_sym]
      end

      def add_mote_definition(mote, mote_definition)
        @mote_definitions[mote_definition.name.to_sym] = mote_definition
      end
    end
  end
end
