module Motivation
  class MotiveBlock
    include MoteDsl

    attr_reader :context

    def initialize(context, motive)
      @context = context
      @motive = motive
    end

    def mote!(name, *motives)
      context.mote! name, *(motives + [@motive])
    end
  end
end
