module Motivation
  class ContextDefinition
    include MoteDsl
    extend Forwardable

    attr_reader :motes, :motivator
    def_delegators :motivator, :has_motive?

    def initialize(motivator)
      @motivator = motivator
      @motes = []
    end

    def context
      self
    end

    def mote!(name, *motives)
      MoteDefinition.new context, name, *motives
    end

    def mote(name, *motives)
      MoteReference.new context, name, *motives
    end

    def motive(name, *args)
      MotiveReference.new context, name, *args
    end

    def add_mote_definition(mote_definition)
      @motes << mote_definition
    end

    def eval_mote_block(mote, &block)
      MoteBlock.new(context, mote).eval &block
    end

    def eval_motive_block(motive, &block)
      MotiveBlock.new(context, motive).eval &block
    end

    # def ==(other)
    #   other.is_a?(ContextDefinition) &&
    #     self.motivator == other.motivator &&
    #     self.motes == other.motes
    #     # This would end up being recursive, since
    #     # MoteDefinition.== checks context
    # end
  end
end
