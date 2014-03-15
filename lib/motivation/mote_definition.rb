module Motivation
  class MoteDefinition
    include MoteDsl

    attr_reader :context, :name, :motives

    def initialize(context, name, *motives)
      @context = context
      @name = name.to_sym
      @motives = motives
    end

    def to_s
      parts = [":#{name}", motives.map(&:to_s).join(", ")].reject &:blank?
      "#mote!(#{parts.join ", "})"
    end

    def ==(other)
      other.is_a?(MoteDefinition) &&
        self.context == other.context &&
        self.name == other.name &&
        self.motives == other.motives
    end

    def motive(name, *args)
      motives << context.motive(name, *args)
      self
    end

    def mote(name)
      raise "Cannot get a mote reference from a mote definition (did you mean to reference a motive?)"
    end
  end
end
