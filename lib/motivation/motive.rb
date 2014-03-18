module Motivation
  class Motive
    attr_reader :parent
    attr_writer :args

    def initialize(parent, *args)
      @parent = parent
      @args = args
    end

    def args
      @args ||= []
    end

    def name
      class_name = self.class.name
      unless class_name
        raise "Motives must be constants or explicitly implement #name"
      end
      class_name.demodulize.sub(/Motive$/, "").underscore.to_sym
    end

    def resolve(*args)
      parent.motivator.motive_resolver.resolve_motive self, *args
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
  end
end

