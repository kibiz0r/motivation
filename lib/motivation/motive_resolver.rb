module Motivation
  class MotiveResolver
    def resolve_reference(motivator, motive_reference)
      motive_class = motivator.find_motive motive_reference.name
      motive_class.new(*motive_reference.args).tap do |motive|
        motive.args = motive_reference.args
      end
    end
  end
end
