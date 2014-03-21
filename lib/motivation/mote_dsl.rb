module Motivation
  module MoteDsl
    extend Forwardable

    # DelegatedToMotivator = %w|
    # |.map &:to_sym
    # def_delegators :motivator, *DelegatedToMotivator

    def eval(&block)
      self.instance_eval &block
    end

    # def motivator
    #   self.parent && self.parent.motivator
    # end

    def mote_definition!(name, *motives)
      MoteDefinition.new self.mote_definition, name, *motives
    end

    def mote_reference(name)
      nil
    end

    def motive_instance!(name, *args)
      MotiveInstance.new self, name, *args
    end

    def eval_mote_block(mote_definition, &block)
      MoteBlock.new(@motivator, mote_definition).eval &block
    end

    def eval_motive_block(motive_instance, &block)
      MotiveBlock.new(@motivator, self.mote_definition, motive_instance).eval &block
    end

    def motive_instance_resolvable?(name)
      false
    end

    def motive_reference_resolvable?(name)
      false
    end

    def add_mote_definition(mote_definition)
      self.mote_definition.add_mote_definition mote_definition
    end

    def add_motive_instance(motive_instance)
      nil
    end

    # def mote(name, *motives)
    #   MoteReference.new self, name, *motives
    # end

    # def motive(name, *args)
    #   MotiveReference.new self, name, *args
    # end

    # def eval_mote_block(mote, &block)
    #   MoteBlock.new(self, mote).eval &block
    # end

    # def eval_motive_block(motive, &block)
    #   MotiveBlock.new(self, motive).eval &block
    # end

    # parent_mote!.namespace.constant do
    #   my_mote!
    # end
    # my_mote.parent == parent_mote

    # def method_missing(method_name, *args, &block)
    #   puts method_name
    # rescue => e
    #   puts "problem handling #{self}.#{method_name}: #{e}\n#{e.backtrace.join "\n"}"
    #   super method_name.to_sym, *args, &block
    # end
  end

  def validate_mote_name!(mote_name)
    if %w|to_ary|.include? mote_name.to_s
      raise "Invalid mote name: \"#{mote_name}\""
    end
  end
end
