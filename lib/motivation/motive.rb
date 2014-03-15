module Motivation
  class Motive
    attr_writer :args

    def args
      @args ||= []
    end

    def name
      self.class.name.demodulize.underscore
    end

    def ==(other)
      other.is_a?(self.class) &&
        self.args == other.args
    end

    def to_s
      parts = [name, args.map(&:to_s).join(", ")].reject &:blank?
      "motive(#{parts.join ", "})"
    end
  end
end

