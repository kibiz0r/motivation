module Motivation
  class Context < Container
    class << self
      attr_accessor :current
      def files; current.files; end
      def files_dependencies; current.files; end
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

    def motivation(*args)
    end

    def files
      []
    end

    def files_dependencies
      {}
    end
  end
end
