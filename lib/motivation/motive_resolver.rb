module Motivation
  class MotiveResolver
    # The simple case here is that we're trying to resolve a Motive attached to the root Mote
    #   In that case, we just need to find if there are any MotiveInstances that would prefer to resolve our target Motive
    #   If there are, then we ask the Mote to resolve them (which probably just triggers this same process)
    #     And then we ask the resolved Motive to resolve our target Motive
    #   Otherwise, we just tell it to resolve itself
    #
    # The next case is that we're trying to resolve a Motive attached to a child of the root Mote
    #   We still need to find if there are any Motives that would prefer to resolve us
    #   If there are, then we ask the Mote to resolve them (which probably just triggers this same process)
    #     And then we ask the resolved Motive to resolve our target Motive
    #   Otherwise, we ask the root Mote to resolve our target Motive
    def resolve_motive(mote, motive, *args)
      mote.scan_preceding_motive_instances motive.instance do |preceding_motive_instance|
        preceding_motive_definition = mote.identify_motive_instance preceding_motive_instance

        if preceding_motive_definition.can_resolve_motive_with_definition? motive.definition
          preceding_motive = mote.resolve_motive_instance preceding_motive_instance

          return preceding_motive.resolve_motive mote, motive, *args
        end
      end

      parent_mote = mote

      while parent_mote = parent_mote.parent and parent_mote.can_resolve_motives?
        parent_mote.scan_motive_instances do |overriding_motive_instance|
          overriding_motive_definition = parent_mote.identify_motive_instance overriding_motive_instance
          if overriding_motive_definition.can_resolve_motive_with_definition? motive.definition
            overriding_motive = parent_mote.resolve_motive_instance overriding_motive_instance

            return overriding_motive.resolve_motive parent_mote, motive, *args
          end
        end
      end

      return motive.resolve_self mote, *args
    end
  end
end
