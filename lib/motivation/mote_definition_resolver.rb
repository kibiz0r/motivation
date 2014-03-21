module Motivation
  class MoteDefinitionResolver
    def resolve_mote_definition(motivator, mote_definition)
      Mote.new motivator, mote_definition
    end
  end
end
