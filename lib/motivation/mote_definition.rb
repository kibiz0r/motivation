module Motivation
  class MoteDefinition
    # I'm not sure this really needs the DSL anymore, since adding expressions
    include MoteDsl

    attr_accessor :parent
    attr_reader :name, :motives

    def initialize(parent, name, *motives)
      self.parent = parent
      @name = name.to_sym if name
      @motives = motives
      motives.each do |motive|
        motive.parent = self
      end
    end

    # def resolve
    #   self.motivator.resolve_mote_definition self
    # end

    # def resolve_motive_definition(motive_definition_name)
    #   # This is where we should look up any renaming of motives
    #   #   e.g. my_mote! module_name: namespace("Foo")
    #   self.motivator.resolve_motive_definition_name motive_definition_name
    # end

    # def motivator
    #   self.parent && self.parent.motivator
    # end

    def motive(name, *args)
      name = name.to_sym
      if motive? name
        if args.any?
          raise "Don't pass arguments to existing motive references (did you mean to create a motive reference?)"
        end
        return @motives[name]
      end
      @motives[name] = super name, *args
      self
    end

    def motive?(name)
      name = name.to_sym
      @motives.has_key? name
    end

    def mote(name)
      raise "Cannot get a mote reference (\"#{name}\") from a mote definition (did you mean to reference a motive?)"
    end

    def mote_definition
      self
    end

    def motive_instance_resolvable?(name)
      raise "the roof"
    end

    def motive_reference_resolvable?(name)
      raise "the roof"
    end

    def add_mote_definition(mote_definition)
      self.parent && self.parent.add_mote_definition(mote_definition)
    end

    def add_motive_instance(motive_instance)
      self.motives << motive_instance
    end

    def eval_motive_block(motive_instance, &block)
      raise "Mote definitions can't eval Motive blocks"
    end

    def to_s
      parts = [
        ":#{name}",
        motives.map(&:to_s).join(", ")
      ].reject &:blank?
      "#{parent}.mote_definition!(#{parts.join ", "})"
    end

    def ==(other)
      other.is_a?(MoteDefinition) &&
        self.parent == other.parent &&
        self.name == other.name &&
        self.motives == other.motives
    end
  end
end
