module Motivation
  class Motive
    extend Forwardable
    include Node

    attr_reader :mote

    def initialize(mote)
      @mote = mote
    end

    def definition
      self.class
    end

    def resolution_name
      self.class.resolution_name
    end

    def self.resolution(node, *args)
      MotiveResolution.new node, *args
    end

    def motive_resolver
      mote.motive_resolver
    end

    # def resolve(mote, *args)
    #   mote.resolve_motive self, *args
    # end
    def resolve(*args)
      Proposal.on walk_nodes_to_root, :propose_resolution, self, *args
      # resolution = Motive.resolution [mote, self],
      #   return: ->(resolved) { return resolved }
      # resolve_motive resolution
    end

    def walk_nodes_to_root
      mote.walk_nodes_from self
    end

    def resolve_motive(resolution)
    end

    # def resolve_motive(mote, motive, *args)
    #   resolve_method = :"resolve_#{motive.resolution_name}"
    #   if self.respond_to? resolve_method
    #     self.send resolve_method, mote, motive, *args
    #   end
    # end

    # def preceding_nodes
    #   Enumerator.new do |yielder|
    #     mote.scan_preceding_motives instance do |motive|
    #       yielder.yield motive
    #     end

    #     yielder.yield mote

    #     mote.preceding_nodes.each do |node|
    #       yielder.yield node
    #     end
    #   end
    # end

    # def ==(other)
    #   other.is_a?(self.class) &&
    #     self.mote == other.mote &&
    #     self.instance == other.instance
    # end

    # def to_s
    #   "#{self.class.name}(#{self.args.map(&:to_s).join(", ")})"
    # end

    class << self
      def instance(*args)
        if args.first.is_a? Symbol
          parent = nil
          name = args.shift
        else
          parent, name = args.slice! 0, 2
        end
        MotiveInstance.new parent, name, *args
      end

      def resolution_name
        name.demodulize.underscore
      end

      # Using #instance_methods is really slow...
      #
      # We can avoid using reflection to answer these questions by passing a
      # continuation-style object up the chain and only opting into providing
      # a return value.
      def can_resolve_motive_with_definition?(motive_definition)
        @resolvable_motives ||= {}

        resolution_name = motive_definition.resolution_name
        can_resolve = @resolvable_motives[resolution_name]

        return can_resolve unless can_resolve.nil?

        @resolvable_motives[resolution_name] = imethods.include? :"resolve_#{motive_definition.resolution_name}"
      end

      def can_identify_motive_instances?
        return @can_identify_motive_instances unless @can_identify_motive_instances.nil?
        @can_identify_motive_instances = imethods.include? :identify_motive_instance
      end

      def can_find_mote_definitions?
        return @can_find_mote_definitions unless @can_find_mote_definitions.nil?
        @can_find_mote_definitions = imethods.include? :find_mote_definition
      end

      def can_add_mote_definitions?
        return @can_add_mote_definitions unless @can_add_mote_definitions.nil?
        @can_add_mote_definitions = imethods.include? :add_mote_definition
      end

      def can_resolve_mote_definitions?
        return @can_resolve_mote_definitions unless @can_resolve_mote_definitions.nil?
        @can_resolve_mote_definitions = imethods.include? :resolve_mote_definition
      end

      def can_resolve_motes?
        return @can_resolve_motes unless @can_resolve_motes.nil?
        @can_resolve_motes = imethods.include? :resolve_mote
      end

      def imethods
        @imethods ||= instance_methods
      end
    end
  end
end

