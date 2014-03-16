module Motivation
  class MoteBlock
    include MoteDsl

    attr_reader :parent

    def initialize(parent, mote)
      @parent = parent
      @mote = mote
    end

    def mote!(name, *motives)
      # TODO: Use something like MoteDsl.target instead of @mote to DRY up {Mote,Motive}Block
      MoteDefinition.new @mote, name, *motives
    end
  end
end
