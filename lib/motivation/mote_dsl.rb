module Motivation
  module MoteDsl
    extend Forwardable

    DELEGATED_TO_CONTEXT = %w|
      mote!
      mote
      motive
      motive_defined?
      add_mote_definition
      eval_mote_block
      eval_motive_block
    |.map &:to_sym
    def_delegators :delegate_to_context, *DELEGATED_TO_CONTEXT

    def eval(&block)
      instance_eval &block
    end

    def delegate_to_context
      raise "#{self.class} must implement #context or override #{DELEGATED_TO_CONTEXT.join ", "}" unless self.respond_to? :context
      context
    end

    def method_missing(name, *args, &block)
      name = name.to_s
      if name.end_with? "!"
        mote!(name.chop, *args).tap do |mote|
          add_mote_definition mote
          eval_mote_block mote, &block if block_given?
        end
      elsif motive_defined?(name)
        motive(name, *args).tap do |motive|
          eval_motive_block motive, &block if block_given?
        end
      else
        mote name, *args
      end
    rescue => e
      raise "problem handling #{self}.#{name}: #{e}"
    end
  end
end
