module Motivation
  class Motive
    extend Forwardable

    def_delegators :instance, :args, :name

    attr_reader :instance

    def initialize(motive_instance)
      @instance = motive_instance
    end

    def definition
      self.class
    end

    def resolution_name
      self.class.resolution_name
    end

    def resolve(mote, *args)
      mote.resolve_motive self, *args
    end

    def resolve_motive(mote, motive, *args)
      resolve_method = :"resolve_#{motive.resolution_name}"
      if self.respond_to? resolve_method
        self.send resolve_method, mote, motive, *args
      end
    end

    def ==(other)
      other.is_a?(self.class) &&
        self.args == other.args
    end

    def to_s
      "#{self.class.name}(#{self.args.map(&:to_s).join(", ")})"
    end

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

      def can_resolve_motive_with_definition?(motive_definition)
        instance_methods.include? :"resolve_#{motive_definition.resolution_name}"
      end

      def can_identify_motive_instances?
        instance_methods.include? :identify_motive_instance
      end

      def can_find_mote_definitions?
        instance_methods.include? :find_mote_definition
      end

      def can_add_mote_definitions?
        instance_methods.include? :add_mote_definition
      end

      def can_resolve_mote_definitions?
        instance_methods.include? :resolve_mote_definition
      end

      def can_resolve_motes?
        instance_methods.include? :resolve_mote
      end
    end
  end
end

