module Motivation
  class SourceConstantResolver
    def initialize(motivator)
      @motivator = motivator
    end

    def resolve_source_const(mote, const_name)
      @motivator.require_source_const const_name
    end
  end
end
