module Motivation
  class MotiveBlock
    include MoteDsl

    attr_reader :parent

    def initialize(parent, motive)
      @parent = parent
      @motive = motive
    end

    def to_s
      "#{self.parent}.#{@motive}->"
    end

    def ==(other)
      other.is_a?(MotiveBlock) &&
        self.parent == other.parent &&
        @motive == other.instance_variable_get(:@motive)
    end

    def mote!(name, *motives)
      MoteDefinition.new @motive, name, *motives
      # TODO: This?
      # MoteDefinition.new self, name, *motives
    end
  end
end
