module Motivation
  class MoteReference
    attr_reader :context, :name

    def initialize(context, name)
      @context = context
      @name = name.to_sym
    end

    def to_s
      "#mote(:#{name})"
    end

    def ==(other)
      other.is_a?(MoteReference) &&
        self.context == other.context &&
        self.name == other.name
    end
  end
end
