module Motivation
  class MotiveInstanceIdentifier
    def identify_motive_instance(mote, motive_instance)
      mote.scan_preceding_motive_instances motive_instance do |preceding_motive_instance|
        preceding_motive_definition = mote.identify_motive_instance preceding_motive_instance

        if preceding_motive_definition.can_identify_motive_instances?
          preceding_motive = mote.resolve_motive_instance preceding_motive_instance

          return preceding_motive.identify_motive_instance mote, motive_instance
        end
      end

      return mote.parent.identify_motive_instance motive_instance
    end
  end
end
