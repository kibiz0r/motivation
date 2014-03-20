module Motivation
  class MoteDefinition
    include MoteDsl

    attr_accessor :parent
    attr_reader :name, :motives

    def initialize(parent, name, *motives)
      self.parent = parent
      @name = name.to_sym if name
      @motives = motives
    end

    def resolve
      self.motivator.resolve_mote_definition self
    end

    def resolve_motive_definition(motive_name)
      # This is where we should look up any renaming of motives
      #   e.g. my_mote! module_name: namespace("Foo")
      self.motivator.resolve_motive_definition motive_name
    end

    def motivator
      self.parent && self.parent.motivator
    end

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
      self.motivator.source_const? "#{name}_motive"
    end

    def motive_reference_resolvable?(name)
      self.motivator.source_const? "#{name}_motive"
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

    def method_missing(method_name, *args, &block)
      name = method_name.to_s
      if invocation = name.end_with?("!")
        name.chop!
      end

      if invocation
        self.mote_definition!(name, *args).tap do |mote_definition|
          puts "adding mote definition #{name}"
          self.add_mote_definition mote_definition
          self.eval_mote_block mote_definition, &block if block_given?
        end
      else
        if self.motive_instance_resolvable? name
          self.motive_instance!(name, *args).tap do |motive_instance|
            self.add_motive_instance motive_instance
          end
          self.eval_mote_block self, &block if block_given?
        else
          validate_mote_name! name
          self.mote_reference name
        end
      end
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
