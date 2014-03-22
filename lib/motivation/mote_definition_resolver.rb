module Motivation
  class MoteDefinitionResolver
    def resolve_mote_definition(motivator, mote_definition)
      if parent_definition = mote_definition.parent
        Mote.new motivator.resolve_mote_definition(parent_definition),
          mote_definition
      else
        raise "Could not resolve #{mote_definition} -- it has no parent and the Motivator couldn't resolve it directly"
      end
    end
  end
end
