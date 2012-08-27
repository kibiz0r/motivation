module Motivation
  class Motion < Context
    def initialize(&block)
      super &block
    end

    def allow_require?
      false
    end
  end
end
