module Motivation
  class MoteResolver
    def resolve_mote(mote_for_context, mote_to_resolve, *args)
      mote_for_context.scan_motive_instances do |motive_instance|
        motive_definition = mote_for_context.identify_motive_instance motive_instance

        if motive_definition.can_resolve_motes?
          motive = mote_for_context.resolve_motive_instance motive_instance

          if resolved = motive.resolve_mote(mote_to_resolve, *args)
            return resolved
          end
        end
      end

      if parent_mote = mote_for_context.parent and parent_mote.can_resolve_motes?
        if resolved = parent_mote.resolve_mote(mote_to_resolve, *args)
          return resolved
        end
      end

      nil
    end
  end
end
