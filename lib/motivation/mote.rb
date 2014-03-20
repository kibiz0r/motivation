module Motivation
  class Mote
    # include MoteDsl

    extend Forwardable

    # Should these use a resolve chain?
    def_delegators :definition, :name

    # def_delegators :motivator, :source_const, :require_source_const
    def_delegators :motivator, *Motivator::Resolvers # TODO: resolve chain

    attr_reader :motivator, :definition

    def self.define(*args)
      parent, name = args.slice! 0, args.find_index { |a| a.is_a? MotiveInstance } || 0
      MoteDefinition.new parent, name, *args
    end

    def motivator
      # I'm actually not sure where the motivator should come from
      self.definition.motivator
    end

    def initialize(definition)
      @definition = definition
    end

    def parent
      self.definition.parent.resolve
    end

    def motive_name(motive)
      self.motive_instances.reverse_each.find do |motive_instance|
        motive_instance.definition == motive.definition
      end
    end

    def motive_instances
      self.definition.motives
    end

    def [](motive_name)
      motive_name = motive_name.to_sym
      motive_instance = self.definition.motives.reverse_each.find do |motive_instance|
        motive_instance.name.to_sym == motive_name
      end
      motive_instance.resolve
    end

    def ==(other)
      other.is_a?(Mote) &&
        self.motivator == other.motivator &&
        self.definition == other.definition
    end

    def to_s
      parts = [
        ":#{self.name}"
      ]
      "#{self.context}: mote(#{parts.join ", "}) source: #{self.definition}"
    end

    def method_missing(method_name, *args, &block)
      motive = self[method_name]
      motive.resolve *args
    end

    # def resolve_mote_reference(mote_reference)
    #   self.context.resolve_mote_reference mote_reference
    # end

    # def resolve_motive_reference(motive_reference)
    #   # TODO: Replace this with generic resolver
    #   if motive_reference.name == :constant
    #     if self[:namespace]
    #       return self[:namespace].resolve_constant_motive_reference motive_reference
    #     end
    #   end
    #   self.motivator.motive_resolver.resolve_motive_reference self, motive_reference
    #   # self.motivator.resolve_motive_reference(motive_reference).resolve self
    # end

    # def resolve
    #   self.definition.motives.each_value do |motive_reference|
    #     motive = self.resolve_motive_reference motive_reference
    #     if motive.respond_to? :resolve_mote
    #       return motive.resolve_mote
    #     end
    #   end

    #   raise "Couldn't resolve #{self}"
    # end

    # def [](motive_name)
    #   if self.definition.motive? motive_name
    #     return self.resolve_motive_reference definition.motive(motive_name)
    #     # return self.motivator.resolve_motive_reference definition.motive(motive_name)
    #   end

    #   nil
    # end

    # def method_missing(method, *args, &block)
    #   # puts "method_missing #{method}"

    #   if self.definition.motive? method
    #     # puts "self.definition.motive? method"
    #     # return self.resolve_motive_reference definition.motive(method)
    #     return self[method].resolve
    #     # return self.motivator.motive_resolver.resolve_motive_reference(self, definition.motive(method)).resolve
    #   end

    #   if self.parent && self.parent.respond_to?(method)
    #     # puts "self.parent && self.parent.respond_to?(method)"
    #     return self.parent.send method, *args, &block
    #   end

    #   # puts "super"
    #   super
    # end

    # def respond_to?(method)
    #   # puts "respond_to? #{method}"
    #   return true if super
    #   return true if self.definition.motive? method
    #   return true if self.parent && self.parent.respond_to?(method)
    #   false
    # end
  end
end
