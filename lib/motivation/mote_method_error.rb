module Motivation
  class MoteMethodError < RuntimeError
    def initialize(method_name, opts = {})
      super self.class.message(method_name, opts)
    end

    def self.message(method_name, opts = {})
      from = opts.delete :from
      included_motives = opts.delete :included_motives
      defined_motives = opts.delete :defined_motives
      msg = "Mote does not respond to '#{method_name}' or include a Motive that would respond first"
      msg += ", which is required for the implementation of #{from}" if from
      msg += "\n\tIncluded motives: #{included_motives}" if included_motives
      msg += "\n\tDefined motives: #{defined_motives}" if defined_motives
      msg
    end
  end
end
