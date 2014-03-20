module Motivation
  class Motive
    extend Forwardable

    def_delegators :mote, :motivator

    attr_reader :mote
    attr_writer :args

    def initialize(mote, *args)
      @mote = mote
      @args = args
    end

    def args
      @args ||= []
    end

    def name
      self.mote.motive_name self
      # class_name = self.class.name
      # unless class_name
      #   raise "Motives must be constants or explicitly implement #name"
      # end
      # class_name.demodulize.sub(/Motive$/, "").underscore.to_sym
    end

    def definition
      self.class
    end

    def resolve(*args)
      self.motivator.resolve_motive self, *args
    end

    def resolve_motive(motive, *args)
      resolve_method = :"resolve_#{motive.class.name.demodulize.underscore}"
      if self.respond_to? resolve_method
        self.send resolve_method, motive, *args
      else
      end
    end

    def ==(other)
      other.is_a?(self.class) &&
        self.args == other.args
    end

    def to_s
      "#{self.class.name}(#{args.map(&:to_s).join(", ")})"
      # parts = [name, args.map(&:to_s).join(", ")].reject &:blank?
      # "[#{self.parent.name}].motive(#{parts.join ", "})"
    end

    def self.instance(*args)
      name_index = args.find_index { |a| a.is_a? Symbol }
      if args.first.is_a? Symbol
        parent = nil
        name = args.slice! 0, 1
      else
        parent, name = args.slice! 0, 2
      end
      MotiveInstance.new parent, name, *args
    end
  end
end

