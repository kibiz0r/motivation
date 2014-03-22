module Motivation
  class Mote
    class NoParent
      def initialize(mote)
        @mote = mote
      end

      def method_missing(method_name, *args, &block)
        raise "Mote #{@mote} must have a parent in order to call #{method_name}"
      end
    end

    extend Forwardable

    # TODO: Remove refernces to Motivator and go through parent instead
    # The root node will have the reference to Motivator and delegate this appropriately
    def_delegators :require_parent,
      :mote_reference_identifier,
      :mote_reference_resolver,
      :motive_reference_identifier,
      :motive_reference_resolver,
      :mote_definition_resolver,
      :mote_resolver,
      :motive_instance_identifier,
      :motive_instance_resolver,
      :motive_resolver,
      :source_constant_resolver

    attr_reader :parent, :definition

    def self.define(*args)
      parent, name = args.slice! 0, args.find_index { |a| a.is_a? MotiveInstance } || 0
      MoteDefinition.new parent, name, *args
    end

    def initialize(parent, definition)
      @parent = parent
      @definition = definition
    end

    def require_parent
      parent || NoParent.new
    end

    # def parent
    #   puts "trying to resolve parent for #{self}"
    #   if self.definition.parent
    #     self.motivator.resolve_mote_definition self.definition.parent
    #   end
    # end

    def motive_name(motive)
      self.motive_instances.reverse_each.find do |motive_instance|
        motive_instance.definition == motive.definition
      end
    end

    def motive_instances
      self.definition.motives
    end

    def resolve_motive_definition_name(motive_definition_name)
      self.motivator.resolve_motive_definition_name motive_definition_name
    end

    def resolve_motive_instance(motive_instance)
      motive_instance_resolver.resolve_motive_instance self, motive_instance
    end

    def resolve_motive(motive, *args)
      motive_resolver.resolve_motive self, motive, *args
    end

    def scan_motive_instances(&block)
      motive_instances.reverse_each &block
    end

    def scan_preceding_motive_instances(motive_instance, &block)
      motive_instances.take_while do |defined_instance|
        defined_instance != motive_instance
      end.reverse_each &block
    end

    def identify_motive_instance(motive_instance)
      motive_instance_identifier.identify_motive_instance self, motive_instance
    end

    def resolve_source_const(const_name)
      source_constant_resolver.resolve_source_const self, const_name
    end

    def [](motive_name)
      motive_name = motive_name.to_sym
      motive_instance = self.definition.motives.reverse_each.find do |motive_instance|
        motive_instance.name.to_sym == motive_name
      end
      if motive_instance
        resolve_motive_instance motive_instance
      end
    end

    def ==(other)
      other.is_a?(Mote) &&
        self.motivator == other.motivator &&
        self.definition == other.definition
    end

    def to_s
      "Mote(#{self.definition})"
    end

    def method_missing(motive_name, *args, &block)
      if motive = self[motive_name]
        resolve_motive motive, *args, &block
      else
        raise "No such motive: #{motive_name}"
      end
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
