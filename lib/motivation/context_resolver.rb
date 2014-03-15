module Motivation
  class ContextResolver
    def resolve_definition(motivator, context_definition)
      Context.new motivator, context_definition
    end
  end
end
