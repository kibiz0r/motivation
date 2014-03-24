module Motivation
  class MotiveInstanceFinder
    def find_motive_instance(mote, motive_instance_name)
      mote.scan_motive_instances do |motive_instance|
        if motive_instance.name == motive_instance_name
          return motive_instance
        end
      end

      if parent = mote.parent
        if parent.respond_to? :find_motive_instance
          return parent.find_motive_instance motive_instance_name
        end
      end

      nil
    end
  end
end
