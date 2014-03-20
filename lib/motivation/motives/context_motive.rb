module Motivation
  module Motives
    class ContextMotive < Motive
      def resolve_mote_definition(mote_definition)
      end

      def resolve_mote_name(mote_name)
        mote_name = mote_name.to_sym

        if mote = @motes[mote_name]
          return mote
        end

        if mote_definition = @mote_definitions[mote_name]
          return resolve_mote_definition mote_definition
        end

        raise "No such mote: #{mote_name}"
      end

      def resolve_mote_definition(mote_definition)
      end
    end
  end
end
