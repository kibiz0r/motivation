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

    def resolve!(name, *args)
      resolvers.inject mote(name).try(:resolve!, *args) do |resolved, resolver|
        resolved._? { resolver.try :resolve!, name, *args }
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
