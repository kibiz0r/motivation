module Motivation
  class MotiveInstanceFinder
    def find_motive_instance(mote, motive_instance_name)
      mote.scan_motive_instances do |motive_instance|
        if motive_instance.name == motive_instance_name
          return motive_instance
        end
      end

      if mote.parent
        return mote.parent.find_motive_instance motive_instance_name
      end

      nil
    end
  end
end
