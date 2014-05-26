# Motes are the main entry point into the resolved world of Motivation.
#
# They straddle the line between the resolved tree of Motes and Motives
# and the unresolved tree of MoteDefinitions and MotiveInstances.
#
# Motes are created by their parents resolving a MoteDefinition. Because of this,
# if you want to define a new Mote, you should pass a MoteDefinition to add_mote_definition
# and then call resolve_mote_definition.
#
# Motes themselves really have no state; they're just an interface to resolving things.
# All of their statefulness is contained in their Motives (which they memoize,
# but are a function of the MotiveInstances in their MoteDefinition and those in the
# Mote's ancestor Motes).
module Motivation
  class Mote
    extend Forwardable

    # To define a Mote, you need to specify at least a name, preferably a parent,
    # and optionally a splat of MotiveInstances.
    def self.define(parent_or_name, *name_and_or_motive_instances)
      if parent_or_name.is_a? MoteDefinition
        parent = parent_or_name
        name = name_and_or_motive_instances.shift
      else
        parent = nil
        name = parent_or_name
      end
      motive_instances = name_and_or_motive_instances
      MoteDefinition.new parent, name, *motive_instances
    end

    # To create a reference to a Mote, that can be resolved to a Mote on-demand,
    # you need a name and preferably a parent. You can also provide args to the resolution.
    def self.reference(parent_or_name, *name_and_or_args)
      if parent_or_name.is_a? MoteDefinition
        parent = parent_or_name
        name = name_and_or_args.shift
      else
        parent = nil
        name = parent_or_name
      end
      args = name_and_or_args
      MoteReference.new parent, name, *args
    end

    # You can ask for a Mote or Motive with [].
    # Doing so will walk the Mote tree back to the root *twice*, consulting the Motives attached to each Mote both times.
    #
    # - First, asking for a MotiveInstance by name.
    # - Second, asking for a MoteDefinition by name.
    #
    # To be honest, it should probably just search for both simultaneously.
    #
    # There's no reason to walk the tree twice, and if a MoteDefinition is meant to eclipse a Motive, it should be able to.
    def [](mote_or_motive_name)
      if motive_instance = find_motive_instance(mote_or_motive_name)
        return resolve_motive_instance motive_instance
      end

      if mote_definition = find_mote_definition(mote_or_motive_name)
        return resolve_mote_definition mote_definition
      end
      
      nil
    end

    # By default, invoking something on a Mote resolves whatever is returned from [].
    def method_missing(mote_or_motive_name, *args, &block)
      if mote_or_motive = self[mote_or_motive_name]
        resolve_mote_or_motive mote_or_motive, *args#, &block
      else
        super mote_or_motive_name, *args, &block
      end
    end

    def resolve_mote_or_motive(mote_or_motive, *args)
      if mote_or_motive.is_a? Mote
        resolve_mote mote_or_motive, *args
      else
        mote_or_motive.resolve *args
      end
    end

    # To create a Mote, you need:
    #
    # - A parent to interact with the Motes above it,
    # which gives a window into the (partially) resolved state of the tree,
    # and also provide Identifiers, Resolvers, and Finders.
    #
    # - A definition, which identifies the Mote in the original, stateless tree.
    # The definition provides a parent definition, a name, and the requested MotiveInstances.
    #
    # The Mote will memoize the concrete Motives that it resolves out of its definition's MotiveInstances,
    # so you always get the same Motive back from [] or method_missing.
    def initialize(parent, definition)
      @parent = parent
      @definition = definition
      @motives = {}
    end

    attr_reader :parent, :definition

    def_delegators :definition, :name

    def motive_instances
      self.definition.motives
    end

    def preceding_nodes
      Enumerator.new do |yielder|
        parent.scan_motives do |motive|
          yielder.yield motive
        end

        yielder.yield parent

        parent.preceding_nodes.each do |node|
          yielder.yield node
        end
      end
    end

    # To resolve nodes from the definition tree, the Mote uses the Resolver provided by its parent
    # and passes itself to identify the context for resolution.
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

    def find_motive(motive_name)
    end

    # def resolve_motive(motive, *args)
      # motive_resolver.resolve_motive self, motive, *args
    def resolve_motive(resolution)
      # resolution.preceding_nodes.each do |resolution, preceding_motive|
      #   preceding_motive.resolve_motive resolving_node, resolution,
      #     return: ->(r) { return r }
      # end
    end

    def walk_nodes_from(starting_node)
      Enumerator.new do |yielder|
        yielder.yield starting_node
        starting_node.preceding_nodes.each do |node|
          yielder.yield node
        end
      end
    end

    def walk_nodes_to_root
      Enumerator.new do |yielder|
        scan_motives do |motive|
          yielder.yield motive
        end
        walk_nodes_from(self).each do |node|
          yielder.yield node
        end
      end
    end

    def resolve(*args)
      proposal = Proposal.new do |proposal, enum, *args|
        node = enum.next
        node.propose_resolution proposal, *args
        proposal.continue
      end
      proposal.call walk_nodes_to_root, self, *args
      # Proposal.through walk_nodes_to_root, self, *args do |proposal, node|
      #   node.propose_resolution proposal
      # end
      # Proposal.on walk_nodes_to_root, :propose_resolution, self, *args
    end

    def propose_resolution(resolution, target)
      if target == self
        resolution.propose do
          :nothing
        end
      end
    end

    def resolve_mote(resolving_node, mote, *args)
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

    def scan_preceding_motives(motive_instance, &block)
      scan_preceding_motive_instances motive_instance do |instance|
        block.call resolve_motive_instance(instance)
      end
    end

    def scan_motives(&block)
      scan_motive_instances do |instance|
        block.call resolve_motive_instance(instance)
      end
    end

    def scan_preceding_motive_instances(motive_instance, &block)
      motive_instances.take_while do |defined_instance|
        defined_instance != motive_instance
      end.reverse_each &block
    end

    def identify_motive_instance(motive_instance)
      motive_instance_identifier.identify_motive_instance self, motive_instance
    end

    def ==(other)
      other.is_a?(Mote) &&
        self.parent == other.parent &&
        self.definition == other.definition
    end

    def to_s
      if self.parent.is_a? Motivator
        "<root>"
      else
        "#{self.name}!"
      end
    end

    def_delegators :source_constant_resolver,
      :require_source_const,
      :source_const,
      :source_const?

    def propose_identification(identification)
    end

    def propose_location(location)
    end

    def locate_node(node_name)
      Proposal.on walk_nodes_from(self), :propose_location, node_name
    end

    def accept_mote_definition(mote_definition)
    end

    # Motes must have a parent in order to walk the tree.
    # Identifiers, Resolvers, and Finders are all provided by the Motivator,
    # or any parent Mote that explicitly provides one.
    def_delegators :require_parent,
      :mote_reference_identifier,
      :mote_reference_resolver,
      :motive_reference_identifier,
      :motive_reference_resolver,
      :mote_definition_resolver,
      :mote_resolver,
      :node_resolver,
      :mote_value_resolver,
      :motive_instance_identifier,
      :motive_instance_resolver,
      :motive_resolver,
      :source_constant_resolver,
      :mote_definition_finder,
      :motive_instance_finder

    class NoParent
      def initialize(mote)
        @mote = mote
      end

      def method_missing(method_name, *args, &block)
        raise "#{@mote} must have a parent in order to call #{method_name}"
      end
    end

    def require_parent
      parent || NoParent.new(self)
    end
  end
end
