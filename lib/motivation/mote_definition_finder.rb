module Motivation
  class MoteDefinitionFinder
    def find_mote_definition(mote, mote_definition_name)
      mote.scan_motive_instances do |motive_instance|
        motive_definition = mote.identify_motive_instance motive_instance

        if motive_definition.can_find_mote_definitions?
          motive = mote.resolve_motive_instance motive_instance

          if mote_definition = motive.find_mote_definition(mote, mote_definition_name)
            return mote_definition
          end
        end
      end

      if mote.parent
        return mote.parent.find_mote_definition mote_definition_name
      end

      nil
    end
  end
end
