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
        ":#{name}"
      ]
      "#{context}: mote(#{parts.join ", "}) source: #{definition}"
    end

    def resolve_mote_reference(mote_reference)
      context.resolve_mote_reference mote_reference
    end

    def resolve_motive_reference(motive_reference)
      motivator.resolve_motive_reference(motive_reference).resolve self
    end

    def resolve
      definition.motives.each_value do |motive_reference|
        motive = motivator.resolve_motive_reference motive_reference
        if motive.respond_to? :resolve_mote
          return motive.resolve_mote self
        end
      end

      raise "Couldn't resolve #{self}"
    end

    def method_missing(method, *args, &block)
      # puts "method_missing #{method}"

      if definition.motive? method
        return resolve_motive_reference definition.motive(method)
      end

      if parent && parent.respond_to?(method)
        return parent.send method, *args, &block
      end

      super
    end

    def respond_to?(method)
      # puts "respond_to? #{method}"
      return true if super
      return true if definition.motive? method
      return true if parent && parent.respond_to?(method)
      false
    end
  end
end
