module Motivation
  class MotiveBlock
    include MoteDsl

    attr_reader :context

    def initialize(context, motive)
      @context = context
      @motive = motive
    end

    def mote!(name, *motives)
      puts "context.mote! #{name}, #{(motives + [@motive]).map(&:to_s).join ", "}"
      context.mote! name, *(motives + [@motive])
    end
  end
end
