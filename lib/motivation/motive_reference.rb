module Motivation
  class MotiveReference
    include MoteDsl

    attr_reader :context, :name, :args

    def initialize(context, name, *args)
      @context = context
      @name = name.to_sym
      @args = args
    end

    def to_s
      parts = [":#{name}", args.map(&:to_s).join(", ")].reject &:blank?
      "#motive(#{parts.join ", "})"
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
