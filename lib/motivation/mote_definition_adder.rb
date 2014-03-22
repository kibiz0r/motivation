module Motivation
  class MoteDefinitionAdder
    def add_mote_definition(mote, activating_mote_definition, new_mote_definition)
      activating_mote_definition.scan_motive_instances do |motive_instance|
        motive_definition = mote.identify_motive_instance motive_instance

        if motive_definition.can_add_mote_definitions?
          if mote = mote.resolve_mote_definition(activating_mote_definition)
            if motive = mote.resolve_motive_instance(motive_instance)
              return motive.add_mote_definition mote, new_mote_definition
            end
          end
        end
      end

      # then we try the same process on the parent definition?
      if parent_mote_definition = activating_mote_definition.parent
        return add_mote_definition mote, parent_mote_definition, new_mote_definition
      end
    end
  end
end
