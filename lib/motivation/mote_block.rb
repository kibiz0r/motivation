module Motivation
  class MoteBlock
    include MoteDsl

    attr_reader :context

    def initialize(context, mote)
      @context = context
      @mote = mote
    end
  end
end
