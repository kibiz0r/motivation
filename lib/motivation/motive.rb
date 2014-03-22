module Motivation
  class Motive
    extend Forwardable

    def_delegators :instance, :args, :name

    attr_reader :instance

    def initialize(motive_instance)
      @instance = motive_instance
    end

    # def name
    #   self.mote.motive_name self
    #   # class_name = self.class.name
    #   # unless class_name
    #   #   raise "Motives must be constants or explicitly implement #name"
    #   # end
    #   # class_name.demodulize.sub(/Motive$/, "").underscore.to_sym
    # end

    def definition
      self.class
    end

    def resolve(mote, *args)
      mote.resolve_motive self, *args
    end

    def resolve_motive(mote, motive, *args)
      resolve_method = :"resolve_#{motive.class.name.demodulize.underscore}"
      puts "trying to resolve via #{resolve_method}"
      if self.respond_to? resolve_method
        self.send resolve_method, mote, motive, *args
      else
      end
    end

    def ==(other)
      other.is_a?(self.class) &&
        self.args == other.args
    end

    def to_s
      "#{self.class.name}(#{self.args.map(&:to_s).join(", ")})"
      # parts = [name, args.map(&:to_s).join(", ")].reject &:blank?
      # "[#{self.parent.name}].motive(#{parts.join ", "})"
    end

    def self.instance(*args)
      name_index = args.find_index { |a| a.is_a? Symbol }
      if args.first.is_a? Symbol
        parent = nil
        name = args.shift
      else
        parent, name = args.slice! 0, 2
      end
      MotiveInstance.new parent, name, *args
    end

    def self.motive_definition_name
      self.name.demodulize.underscore
    end

    def self.can_resolve_motive_with_definition?(motive_definition)
      self.instance_methods.include? :"resolve_#{motive_definition.motive_definition_name}"
    end

    def self.can_identify_motive_instances?
      self.instance_methods.include? :identify_motive_instance
    end
  end
end

