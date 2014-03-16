module Motivation
  module MoteDsl
    extend Forwardable

    DELEGATED_TO_CONTEXT = %w|
      motive_defined?
      add_mote_definition
    |.map &:to_sym
    def_delegators :context, *DELEGATED_TO_CONTEXT

    def eval(&block)
      instance_eval &block
    end

    def context
      unless self.respond_to? :parent
        raise "#{self.class} must implement #context or #parent"
      end
      self.parent.context
    end

    def mote!(name, *motives)
      MoteDefinition.new self, name, *motives
    end

    def mote(name, *motives)
      MoteReference.new self, name, *motives
    end

    def motive(name, *args)
      MotiveReference.new self, name, *args
    end

    def eval_mote_block(mote, &block)
      MoteBlock.new(self, mote).eval &block
    end

    def eval_motive_block(motive, &block)
      MotiveBlock.new(self, motive).eval &block
    end

    def method_missing(name, *args, &block)
      name = name.to_s
      if name.end_with? "!"
        self.mote!(name.chop, *args).tap do |mote|
          self.add_mote_definition mote
          self.eval_mote_block mote, &block if block_given?
        end
      elsif self.motive_defined?(name)
        self.motive(name, *args).tap do |motive|
          self.eval_motive_block motive, &block if block_given?
        end
      else
        self.mote name, *args
      end
    rescue => e
      # puts "problem handling #{self}.#{name}: #{e}"
      super name.to_sym, *args, &block
    end
  end
end
