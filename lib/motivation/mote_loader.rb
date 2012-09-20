module Motivation
  class MoteLoader
    undef :display

    def initialize(container)
      @container = container
    end

    def load_string(str)
      instance_eval str
    end

    def require(motefile)
      instance_eval File.read(motefile), motefile
    end

    def eval(&block)
      instance_eval &block
    end

    def motivation(*args)
      @container.motivation *args
    end

    def method_missing(*args, &block)
      if block_given?
        MoteLoader.new(@container.container! *args).eval &block
      else
        @container.mote! *args, &block
      end
    end
  end
end
