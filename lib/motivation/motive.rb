# module Motivation
#   module Motives
#   end
# 
#   module Motive
#     attr_accessor :motive_name, :opt_defaults
# 
#     def process_opt(mote, opt_name)
#       default_value = opt_defaults[opt_name.to_sym]
#       if default_value.is_a? Proc
#         mote.instance_exec &default_value
#       elsif default_value.duplicable?
#         default_value.dup
#       else
#         default_value
#       end
#     end
# 
#     def opts
#       opt_defaults.keys
#     end
# 
#     def self.new(*args, &block)
#       opts = args.extract_options!
#       motive_name, _ = args
# 
#       if motive_name
#         constant_name = motive_name.to_s.camelize :upper
#         if Motives.const_defined? constant_name, false
#           Motives.const_get constant_name
#         else
#           Motives.const_set constant_name, Module.new
#         end
#       else
#         Module.new
#       end.tap do |mod|
#         mod.extend self
#         mod.motive_name = motive_name
#         mod.opt_defaults = opts
#         mod.module_eval &block if block_given?
#       end
#     end
#   end
# end
