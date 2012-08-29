module Motivation
  class Resolver
    def initialize(pattern, &block)
      @pattern = pattern
      @block = block
    end

    def resolve!(name, *args)
      match = name.match @pattern
      if match
        block.call *match.captures, *args
      end
    end
  end
end
