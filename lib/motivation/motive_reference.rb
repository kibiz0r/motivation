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
        ":#{name}",
        args.map(&:to_s).join(", ")
      ].reject &:blank?
      "#{parent}.motive(#{parts.join ", "})"
    end

    def ==(other)
      other.is_a?(MotiveReference) &&
        self.context == other.context &&
        self.name == other.name && 
        self.args == other.args
    end

    def mote!(name, *motives)
      context.mote! name, *(motives + [self])
    end
  end
end
