# module Motivation
#   class Context < Container
#     class << self
#       attr_accessor :current
#     end
# 
#     attr_accessor :locators
# 
#     def initialize(*args)
#       Context.current = self
#       opts = args.extract_options!
#       @locators = opts.delete(:locators)._? []
#       motives = opts.delete(:motives)._? []
#       super *args, opts
#       @motives = motives
#       @context = self
#     end
# 
#     def motivation(*args)
#       # opts = args.extract_options!
#       # path, _ = args
#     end
# 
#     def files
#       motes.map { |_, m| m.require_method :file, from: "Context#files" }.compact
#     end
# 
#     def file_dependencies
#       Hash[motes.map do |_, mote|
#         [mote.file, mote.required_mote_files] if mote.file
#       end]
#     end
# 
#     def locate_mote(mote_name, *args)
#       locators.inject(mote(mote_name)) do |located, locator|
#         located._? { locator.try :locate, self, mote_name, *args }
#       end
#     end
# 
#     def namespace
#       ''
#     end
# 
#     def require_mote(mote_name, *args)
#       locate_mote(mote_name, *args)._? { raise "No such mote '#{mote_name}' amongst #{motes.keys}" }
#     end
# 
#     def resolve_mote!(mote_name, *args)
#       require_mote(mote_name, *args).resolve! *args
#     end
#   end
# end
