module Motivation
  class MoteLoader
    def initialize(container)
      @container = container
    end

    def require(motefile)
      instance_eval File.read(motefile), motefile
    end

    def motivation(*args)
      @container.motivation *args
    end

    def method_missing(*args, &block)
      if block_given?
        @container.container! *args, &block
      else
        @container.mote! *args, &block
      end
    end
  end
end
