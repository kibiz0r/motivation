module Motivation
  class MoteResolver
    # def resolve_definition(context, mote_definition, *motives)
    #   Mote.new context, mote_definition, *motives
    # end

    # resolves to => mote
    def resolve_mote_definition(parent, mote_definition)
      Mote.new parent, mote_definition
    end

    def resolve_mote(mote)
    end
  end
end
