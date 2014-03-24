module Motivation
  class MoteDefinition
    # I'm not sure this really needs the DSL anymore, since adding expressions
    include MoteDsl

    attr_accessor :parent
    attr_reader :name, :motives, :value, :template

    # TODO: Can probably turn value and template functionality into ValueMotive and TemplateMotive
    # and just automatically attach appropriate MotiveInstances in the constructor
    def initialize(parent, name, *value_or_template_and_motives)
      self.parent = parent
      @name = name.to_sym if name

      @motives = []
      if value_or_template_and_motives.any?
        if !value_or_template_and_motives.last.is_a?(MotiveInstance)
          value_or_template = value_or_template_and_motives.pop
          @motives = value_or_template_and_motives

          if value_or_template.is_a? MoteReference# or value_or_template.is_a? MotiveReference
            @motives << Motive.instance(:template, value_or_template)
          else
            @motives << Motive.instance(:value, value_or_template)
          end
        else
          @motives = value_or_template_and_motives
        end
      end

      @motives.each do |motive|
        motive.parent = self
      end
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

    def scan_motive_instances(&block)
      motives.reverse_each &block
    end

    def mote_definition
      self
    end

    def add_motive_instance(motive_instance)
      self.motives << motive_instance
    end

    def to_s
      "MoteDefinition(#{[parent, name, *motives].compact.map(&:to_s).join ", "})"
    end

    def ==(other)
      other.is_a?(MoteDefinition) &&
        self.parent == other.parent &&
        self.name == other.name &&
        self.motives == other.motives
    end
  end
end
