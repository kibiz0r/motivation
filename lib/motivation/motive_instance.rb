module Motivation
  class MotiveInstance
    include MoteDsl

    attr_reader :parent, :name, :args

    def initialize(parent, name, *args)
      self.parent = parent
      @name = name
      @args = args
    end

    def parent=(parent)
      @parent = parent
      unless parent.nil? or parent.motives.include? self
        parent.add_motive_instance self
      end
    end

    def resolve(*args)
      self.motivator.resolve_motive_instance self
    end
  end
end
