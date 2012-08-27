module Motivation
  class ContextLoader
    def self.load(motefile)
      Motivation::ContextLoader.new(Motivation::Context.new).load motefile
    end

    def self.require(motefile)
      Motivation::ContextLoader.new(Motivation::Context.new).require motefile
    end

    attr_reader :context

    def initialize(context)
      @context = context
    end

    def load(motefile)
      instance_eval File.read(motefile), motefile
      context
    end

    def require(motefile)
      instance_eval File.read(motefile), motefile
      context.require
    end

    def motivation(*args)
      context.motivation *args
    end

    def scan!(glob = "#{context.path}/*.rb")
      context.scan! glob
    end

    private
    def method_missing(method, *args, &block)
      if block_given?
        context.namespace! method, *args, &block
      else
        context.mote! method, *args
      end
    end
  end
end
