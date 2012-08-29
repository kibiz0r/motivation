module Motivation
  class Context < Container
    class << self
      attr_accessor :current
    end

    attr_accessor :resolvers

    def initialize
      Context.current = self
      @resolvers = []
      super
    end

    def resolve!(name)
      resolvers.inject mote(name) do |resolved, resolver|
        resolved || resolver.resolve!(name)
      end
    end
  end
end
