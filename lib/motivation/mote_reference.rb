module Motivation
  class MoteReference
    include MoteDsl

    attr_reader :parent, :name

    def initialize(parent, name)
      @parent = parent
      @name = name.to_sym
    end

    def to_s
      ".mote(:#{name})"
    end

    def ==(other)
      other.is_a?(MoteReference) &&
        self.parent == other.parent &&
        self.name == other.name
    end
  end
end
