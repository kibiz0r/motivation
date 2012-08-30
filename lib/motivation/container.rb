module Motivation
  class Container
    include MoteLike

    def initialize(*args)
      @containers = {}
      @motes = {}
      super
    end

    def container!(name, opts = {})
      Motivation::Container.new(self, opts.merge(name: name, motives: @motives)).tap { |c| @containers[name] = c }
    end

    def container(name)
      @containers[name]
    end

    def containers
      @containers.values
    end

    def mote!(name, opts = {})
      Motivation::Mote.new(self, opts.merge(name: name)).tap { |m| @motes[name] = m }
    end

    def mote(name)
      @motes[name]
    end

    def motes
      @motes.values
    end
  end
end
