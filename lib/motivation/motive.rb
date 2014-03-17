module Motivation
  class Motive
    attr_reader :parent
    attr_writer :args

    def initialize(parent)
      @parent = parent
    end

    def args
      @args ||= []
    end

    def name
      class_name = self.class.name
      unless class_name
        raise "Motives must be constants or explicitly implement #name"
      end
      class_name.demodulize.underscore.sub(/Motive$/, "").to_sym
    end

    def ==(other)
      other.is_a?(self.class) &&
        self.args == other.args
    end

    def to_s
      parts = [name, args.map(&:to_s).join(", ")].reject &:blank?
      "[#{self.parent.name}].motive(#{parts.join ", "})"
    end
  end
end

