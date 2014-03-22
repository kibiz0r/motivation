module Motivation
  class MoteDefinitionExpression
    extend Forwardable

    include MoteDsl

    attr_reader :mote_definition

    def_delegators :mote_definition, :add_mote_definition
    def_delegators :motivator,
      :motive_instance_resolvable?,
      :motive_reference_resolvable?

    def initialize(motivator, mote_definition)
      @motivator = motivator
      @mote_definition = mote_definition
    end

    def add_mote_definition(mote_definition)
      @motivator.mote_definition_adder.add_mote_definition @motivator, @mote_definition, mote_definition
    end

    def mote_definition!(name, *motives)
      MoteDefinition.new self.mote_definition, name, *motives
    end

    def motive_instance!(name, *args)
      MotiveInstance.new self.mote_definition, name, *args
    end

    def motive_instance_resolvable?(name)
      raise "the roof" if name.to_s == "motives"
      @motivator.motive_definition_name_resolvable? name
    end

    def mote_reference(name)
      raise "the roof"
    end

    def method_missing(method_name, *args, &block)
      name = method_name.to_s
      if invocation = name.end_with?("!")
        name.chop!
      end

      if invocation
        self.mote_definition!(name, *args).tap do |mote_definition|
          self.add_mote_definition mote_definition
          self.eval_mote_block mote_definition, &block if block_given?
        end
      else
        if self.motive_instance_resolvable? name
          self.motive_instance!(name, *args).tap do |motive_instance|
            self.add_motive_instance motive_instance
          end
          self.eval_mote_block self.mote_definition, &block if block_given?
        else
          validate_mote_name! name
          self.mote_reference name
        end
      end
    end
  end
end
