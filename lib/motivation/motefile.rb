module Motivation
  class Motefile
    def self.eval(motefile_string = nil, &block)
      MotefileBlock.new.eval motefile_string, &block
    end
  end
end
