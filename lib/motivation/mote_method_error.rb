module Motivation
  class MoteMethodError < RuntimeError
    def initialize(method_name, opts = {})
      super self.class.message(method_name, opts)
    end

    def self.message(method_name, opts = {})
      from = opts.delete :from
      "Mote does not respond to '#{method_name}'#{", which is required for the implementation of #{from}" if from}"
    end
  end
end
