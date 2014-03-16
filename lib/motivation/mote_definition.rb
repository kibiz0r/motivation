module Motivation
  class MoteDefinition
    include MoteDsl

    attr_reader :parent, :name, :motives

    def initialize(parent, name, *motives)
      @parent = parent
      @name = name.to_sym
      @motives = motives.extract_options!
      motives.each do |motive|
        if @motives.has_key? motive.name
          multiple = [@motives[motive.name], motive]
          raise "Multiple motives with name \"#{motive.name}\": #{multiple.join ", "}"
        end
        @motives[motive.name] = motive
      end
    end

    def to_s
      parts = [
        ":#{name}",
        motives.map { |kv| kv.map(&:to_s).join ": " }.join(", ")
      ].reject &:blank?
      "#{parent}.mote!(#{parts.join ", "})"
    end

    def ==(other)
      other.is_a?(MoteDefinition) &&
        self.parent == other.parent &&
        self.name == other.name &&
        self.motives == other.motives
    end

    def motive(name, *args)
      name = name.to_sym
      if motive? name
        if args.any?
          raise "Don't pass arguments to existing motive references (did you mean to create a motive reference?)"
        end
        return @motives[name]
      end
      @motives[name] = context.motive(name, *args)
      self
    end

    def motive?(name)
      name = name.to_sym
      @motives.has_key? name
    end

    def mote(name)
      raise "Cannot get a mote reference (\"#{name}\") from a mote definition (did you mean to reference a motive?)"
    end
  end
end
