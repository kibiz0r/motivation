# module Motivation
#   class MoteOptError < RuntimeError
#     def initialize(opt_name, opts = {})
#       super self.class.message opt_name, opts
#     end
# 
#     def self.message(opt_name, opts = {})
#       from = opts.delete :from
#       included_motives = opts.delete :included_motives
#       defined_motives = opts.delete :defined_motives
#       msg = "Mote does not specify '#{opt_name}' or include a Motive that would provide a default value"
#       msg += ", which is required for the implementation of #{from}" if from
#       msg += "\n\tIncluded motives: #{included_motives}" if included_motives
#       msg += "\n\tDefined motives: #{defined_motives}" if defined_motives
#       msg
#     end
#   end
# end
