module Motivation
  class Mote
    class NoParent
      def initialize(mote)
        @mote = mote
      end

      def method_missing(method_name, *args, &block)
        raise "#{@mote} must have a parent in order to call #{method_name}"
      end
    end

    extend Forwardable

    def_delegators :require_parent,
      :mote_reference_identifier,
      :mote_reference_resolver,
      :motive_reference_identifier,
      :motive_reference_resolver,
      :mote_definition_resolver,
      :mote_resolver,
      :mote_value_resolver,
      :motive_instance_identifier,
      :motive_instance_resolver,
      :motive_resolver,
      :source_constant_resolver,
      :mote_definition_finder,
      :motive_instance_finder

    def_delegators :source_constant_resolver,
      :require_source_const,
      :source_const,
      :source_const?

    attr_reader :parent, :definition

    def self.define(*args)
      parent = nil

      if args.first.is_a? MoteDefinition
        parent, name = args.slice! 0, 2
      else
        name = args.shift
      end

      MoteDefinition.new parent, name, *args
    end

    def self.reference(*args)
      if args.first.is_a? String or args.first.is_a? Symbol
        MoteReference.new nil, *args
      else
        MoteReference.new *args
      end
    end

    def initialize(parent, definition)
      @parent = parent
      @definition = definition
      @motives = {}
    end

    def require_parent
      parent || NoParent.new(self)
    end

    def motive_instances
      self.definition.motives
    end

    def resolve_mote_definition(mote_definition)
      mote_definition_resolver.resolve_mote_definition self, mote_definition
    end

    def resolve_mote_reference(mote_reference)
      mote_reference_resolver.resolve_mote_reference self, mote_reference
    end

    def find_mote_definition(mote_definition_name)
      mote_definition_finder.find_mote_definition self, mote_definition_name
    end

    def find_motive_instance(motive_instance_name)
      motive_instance_finder.find_motive_instance self, motive_instance_name
    end

    def resolve_motive_instance(motive_instance)
      if motive = @motives[motive_instance]
        return motive
      end

      motive_instance_resolver.resolve_motive_instance(self, motive_instance).tap do |motive|
        @motives[motive_instance] = motive
      end
    end

    def resolve_motive(motive, *args)
      motive_resolver.resolve_motive self, motive, *args
    end

    def resolve_value
      mote_value_resolver.resolve_mote_value self
    end

    def resolve(*args)
      resolve_mote self, *args
    end

    def resolve_mote(mote, *args)
      mote_resolver.resolve_mote self, mote, *args
    end

    def can_resolve_motes?
      respond_to? :resolve_mote
    end

    def can_resolve_motives?
      respond_to? :resolve_motive
    end

    def can_resolve_mote_definitions?
      respond_to? :resolve_mote_definition
    end

    def can_find_mote_definitions?
      respond_to? :find_mote_definition
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

    def [](mote_or_motive_name)
      if motive_instance = find_motive_instance(mote_or_motive_name)
        return resolve_motive_instance motive_instance
      end

      if mote_definition = find_mote_definition(mote_or_motive_name)
        return resolve_mote_definition mote_definition
      end
      
      raise "No such mote or motive: #{mote_or_motive_name}"
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
  end
end
