module Motivation
  class Mote
    extend Forwardable

    def_delegators :definition, :name
    def_delegators :motivator, :source_const, :require_source_const
    def_delegators :context, :motivator
    def_delegators :parent, :context

    attr_reader :parent, :definition

    def initialize(parent, definition)
      @parent = parent
      @definition = definition
    end

    def ==(other)
      other.is_a?(Mote) &&
        self.parent == other.parent &&
        self.definition == other.definition
    end

    def to_s
      parts = [
        ":#{self.name}"
      ]
      "#{self.context}: mote(#{parts.join ", "}) source: #{self.definition}"
    end

    def resolve_mote_reference(mote_reference)
      self.context.resolve_mote_reference mote_reference
    end

    def resolve_motive_reference(motive_reference)
      self.motivator.motive_resolver.resolve_motive_reference self, motive_reference
      # self.motivator.resolve_motive_reference(motive_reference).resolve self
    end

    def resolve
      self.definition.motives.each_value do |motive_reference|
        motive = self.resolve_motive_reference motive_reference
        if motive.respond_to? :resolve_mote
          return motive.resolve_mote self
        end
      end

      raise "Couldn't resolve #{self}"
    end

    def [](motive_name)
      if self.definition.motive? motive_name
        return self.resolve_motive_reference definition.motive(motive_name)
        # return self.motivator.resolve_motive_reference definition.motive(motive_name)
      end

      nil
    end

    def method_missing(method, *args, &block)
      # puts "method_missing #{method}"

      if self.definition.motive? method
        # puts "self.definition.motive? method"
        # return self.resolve_motive_reference definition.motive(method)
        return self.motivator.motive_resolver.resolve_motive_reference(self, definition.motive(method)).resolve
      end

      if self.parent && self.parent.respond_to?(method)
        # puts "self.parent && self.parent.respond_to?(method)"
        return self.parent.send method, *args, &block
      end

      # puts "super"
      super
    end

    def respond_to?(method)
      # puts "respond_to? #{method}"
      return true if super
      return true if self.definition.motive? method
      return true if self.parent && self.parent.respond_to?(method)
      false
    end
  end
end
