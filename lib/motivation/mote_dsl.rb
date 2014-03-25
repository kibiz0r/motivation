module Motivation
  module MoteDsl
    extend Forwardable

    def eval(string = nil, &block)
      if string
        self.instance_eval string, __FILE__, __LINE__
      elsif block_given?
        self.instance_eval &block
      end
    end

    def mote_definition!(name, *motives)
      MoteDefinition.new self.mote_definition, name, *motives
    end

    def mote_reference(name, *args)
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

    def add_motive_instance(motive_instance)
      nil
    end

    def validate_mote_name!(mote_name)
      if %w|to_ary|.include? mote_name.to_s
        raise "Invalid mote name: \"#{mote_name}\""
      end
    end
  end
end
