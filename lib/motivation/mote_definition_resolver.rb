module Motivation
  class MoteDefinitionResolver
    def resolve_mote_definition(motivator, mote_definition)
      raise "Nil MoteDefinition" unless mote_definition
      Mote.new mote_definition
    end
  end
end
