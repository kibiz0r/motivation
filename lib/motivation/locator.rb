module Motivation
  class Locator
    def initialize(pattern, &block)
      @pattern = pattern
      @block = block
    end

    def locate(context, name, *args)
      match = name.match @pattern
      if match
        context.instance_exec *match.captures, *args, &@block
      end
    end
  end
end
