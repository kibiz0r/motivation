module Motivation
  class Container
    include MoteLike

    def initialize(*args)
      @containers = {}
      @motes = {}
      super
    end

    def container!(name)
      Motivation::Container.new(self, name: name, motives: @motives).tap { |c| @containers[name] = c }
    end

    def container(name)
      @containers[name]
    end

    def containers
      @containers.values
    end

    def mote!(name)
      Motivation::Mote.new(self, name: name).tap { |m| @motes[name] = m }
    end

    def mote(name)
      @motes[name]
    end

    def motes
      @motes.values
    end
  end
end
