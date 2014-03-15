module Motivation
  class MoteResolver
    def resolve_definition(context, mote_definition, *motives)
      Mote.new context, mote_definition, *motives
    end
  end
end
