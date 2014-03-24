module Motivation
  class MoteValueResolver
    # TODO: Allow Motives to intercept resolve_mote_value
    def resolve_mote_value(mote)
      if value = mote.definition.value
        return value
      elsif template_reference = mote.definition.template
        template_mote = mote.resolve_mote_reference template_reference
        return template_mote.resolve_value
      end

      nil
    end
  end
end
