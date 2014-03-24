module Motivation
  class MoteDefinitionResolver
    def resolve_mote_definition(mote, mote_definition)
      if mote.definition == mote_definition
        return mote
      end

      mote.scan_motive_instances do |motive_instance|
        motive_definition = mote.identify_motive_instance motive_instance

        if motive_definition.can_resolve_mote_definitions?
          motive = mote.resolve_motive_instance motive_instance

          if resolved = motive.resolve_mote_definition(mote, mote_definition)
            return resolved
          end
        end
      end

      if parent_mote = mote.parent and parent_mote.can_resolve_mote_definitions?
        if resolved = parent_mote.resolve_mote_definition(mote_definition)
          return resolved
        end
      end

      nil
    end
  end
end
