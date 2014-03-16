module Motivation
  class MotiveBlock
    include MoteDsl

    attr_reader :parent

    def initialize(parent, motive)
      @parent = parent
      @motive = motive
    end

    def mote!(name, *motives)
      MoteDefinition.new @motive, name, *motives
    end
  end
end
