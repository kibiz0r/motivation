module Motivation
  class MoteOptError < RuntimeError
    def initialize(opt_name, opts = {})
      super self.class.message opt_name, opts
    end

    def self.message(opt_name, opts = {})
      from = opts.delete :from
      "Mote does not specify '#{opt_name}' or include a Motive that would provide a default#{", which is required for the implementation of #{from}" if from}"
    end
  end
end
