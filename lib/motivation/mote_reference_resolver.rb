module Motivation
  class MoteReferenceResolver
    def resolve_mote_reference(mote, mote_reference)
      if mote_definition = mote.find_mote_definition(mote_reference.name)
        return mote.resolve_mote_definition mote_definition
      else
        raise "Could not find a MoteDefinition for #{mote_reference}"
      end
    end
  end
end
