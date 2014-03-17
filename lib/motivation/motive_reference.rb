module Motivation
  class MotiveReference
    include MoteDsl

    attr_reader :parent, :name, :args

    def initialize(parent, name, *args)
      @parent = parent
      @name = name.to_sym
      @args = args
    end

    def to_s
      parts = [
        ":#{self.name}",
        self.args.map(&:to_s).join(", ")
      ].reject &:blank?
      "#{self.parent.name}.motive_reference(#{parts.join ", "})"
    end

    def ==(other)
      other.is_a?(MotiveReference) &&
        self.parent == other.parent &&
        self.name == other.name && 
        self.args == other.args
    end

    def mote!(name, *motives)
      self.context.mote! name, *(motives + [self])
    end
  end
end
