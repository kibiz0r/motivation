module Motivation
  class MotiveInstance
    include MoteDsl

    attr_reader :parent, :name, :args

    def initialize(parent, name, *args)
      self.parent = parent
      @name = name.to_sym
      @args = args
    end

    def parent=(parent)
      @parent = parent
      unless parent.nil? or parent.motives.include? self
        parent.add_motive_instance self
      end
    end

    def dup
      MotiveInstance.new self.parent, self.name, *self.args
    end

    def to_s
      "MotiveInstance(#{[name, *args].map(&:to_s).join ", "})"
    end
  end
end
