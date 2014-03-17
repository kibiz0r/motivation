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
  end
end
