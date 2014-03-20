module Motivation
  class MotiveResolver
    def resolve_reference(motivator, motive_reference)
      motive_class = motivator.motive_definition motive_reference.name
      motive_class.new(*motive_reference.args).tap do |motive|
        motive.args = motive_reference.args
      end
    end

    def resolve_motive_reference(mote, motive_reference)
      mote.motivator.motive_definition(motive_reference.name).new mote, *motive_reference.args
    end

    def resolve_motive(motivator, motive, *args)
      if motive.mote && motive.mote.motive_instances
        starting_index = motive.mote.motive_instances.find_index do |motive_instance|
          motive_instance == motive.instance
        end
        # find the earliest match for this motive, and starting there...
        # scan backwards through motive instances for something that resolves this motive definition
      else
        motive.resolve_self *args
      end
    end
  end
end
