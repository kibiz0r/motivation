module Motivation
  class Mote
    extend Forwardable

    def_delegators :definition, :name
    def_delegators :motivator, :source_const, :require_source_const
    def_delegators :context, :motivator

    attr_reader :context, :definition

    def initialize(context, definition)
      @context = context
      @definition = definition
    end

    def ==(other)
      other.is_a?(Mote) &&
        self.context == other.context &&
        self.definition == other.definition
    end

    def to_s
      parts = [":#{name}"]
      "#{context}: mote(#{parts.join ", "}) source: #{definition}"
    end

    def resolve_mote_reference(mote_reference)
      context.resolve_mote_reference mote_reference
    end

    def resolve_motive_reference(motive_reference)
      motivator.resolve_motive_reference(motive_reference).resolve self
    end

    def resolve
      definition.motives.each_value do |motive_reference|
        motive = motivator.resolve_motive_reference motive_reference
        if motive.respond_to? :resolve_mote
          return motive.resolve_mote self
        end
      end

      raise "Couldn't resolve #{self}"
    end

    # ?
    def method_missing(method, *args, &block)
      if definition.motive? method
        return resolve_motive_reference definition.motive(method)
      end

      super
      # motives.each do |motive|
      #   if motive.respond_to? method
      #     return motive.send method, self, *args, &block
      #   end
      # end
      # super
    end

    def respond_to?(method)
      return true if super
      return true if definition.motive? method
      false
      # motives.each do |motive|
      #   if motive.respond_to? method
      #     return true
      #   end
      # end
      # false
    end
  end
#   class Mote
#     attr_accessor :parent, :motes
# 
#     def initialize(parent, *args)
#       @parent = parent
#       @motes = {}
#       # p args.map { |a| a.camelize.constantize }
#     end
# 
#     def context
#       parent.context
#     end
# 
#     def mote!(name, *motives, &block)
#       Mote.new(self, *motives).tap do |mote|
#         motes[name.to_sym] = mote
#         mote.eval &block if block_given?
#       end
#     end
# 
#     def motive!(name, *args, &block)
#       motiveType = context.motives[name.to_sym]
#       puts "no such motive: #{name}"
#       MotiveLoader.new(context, motiveType.new(*args)).tap do |motiveLoader|
#         motiveLoader.eval &block if block_given?
#       end
#     end
# 
#     def eval(&block)
#       instance_eval &block
#     end
# 
#     def method_missing(name, *args, &block)
#       if context.motives.include? name
#         motive! name, *args, &block
#       else
#         mote! name, *args, &block
#       end
#     end
# #     attr_reader :name, :parent, :motives, :context
# # 
# #     def initialize(*args)
# #       @opts = args.extract_options!
# #       @name = @opts.delete(:name).to_s
# #       @parent = @opts.delete(:parent)
# #       @context = @opts.delete(:context)
# #       @motives = @opts.delete(:motives)._? []
# # 
# #       @motives.each do |motive|
# #         extend motive
# #       end
# #     end
# # 
# #     def is_mote?
# #       true
# #     end
# # 
# #     def locate_mote(mote_name)
# #       context.try :locate_mote, mote_name
# #     end
# # 
# #     def opt(opt_name)
# #       specified_opt(opt_name)._? { motive_opt(opt_name) }
# #     end
# # 
# #     def require_opt(opt_name, raise_opts = {})
# #       raise_unless_opt opt_name, raise_opts.merge(included_motives: motives, defined_motives: Motivation.motives)
# #       opt opt_name
# #     end
# # 
# #     def require_method(method_name, raise_opts = {})
# #       raise_unless_method method_name, raise_opts.merge(included_motives: motives, defined_motives: Motivation.motives)
# #       send method_name
# #     end
# # 
# #     def args
# #       @opts
# #     end
# # 
# #     def raise_unless_method(method_name, opts = {})
# #       return if respond_to? method_name
# #       raise MoteMethodError.new method_name, opts
# #     end
# # 
# #     def raise_unless_opt(opt_name, opts = {})
# #       return if opt? opt_name
# #       raise MoteOptError.new opt_name, opts
# #     end
# # 
# #     def constant
# #     end
# # 
# #     def require!(*args)
# #     end
# # 
# #     def resolve!(*args)
# #     end
# # 
# #     def pseudo(opts)
# #       default_opts = motive_opts.merge(specified_opts).merge(motives: motives, parent: parent, context: context)
# #       Mote.new default_opts.merge(opts)
# #     end
# # 
# #     def resolve_mote!(mote, *args)
# #       @context.resolve_mote! mote, *args
# #     end
# # 
# #     def inherited_opt(opt_name, default = nil)
# #       parent.try(:opt, opt_name.to_sym)._? default
# #     end
# # 
# #     def mote(*args)
# #       parent.try :mote, *args
# #     end
# # 
# #     def mote!(*args)
# #       parent.try :mote!, *args
# #     end
# # 
# #     def ==(other)
# #       other.is_a?(self.class) &&
# #         self.name == other.name &&
# #         self.parent.equal?(other.parent)
# #     end
# # 
# #     private
# #     def specified_opt(opt_name)
# #       @opts[opt_name.to_sym]
# #     end
# # 
# #     def specified_opts
# #       @opts
# #     end
# # 
# #     def motive_opts
# #       motives.inject({}) do |opts, motive|
# #         opts.merge Hash[motive.opts.map do |opt_name|
# #           [opt_name, motive.process_opt(self, opt_name)]
# #         end]
# #       end
# #     end
# # 
# #     def motive_opt(opt_name)
# #       motive(opt_name).try :process_opt, self, opt_name
# #     end
# # 
# #     def opt?(opt_name)
# #       @opts.has_key?(opt_name.to_sym) || motive?(opt_name)
# #     end
# # 
# #     def motive?(opt_name)
# #       !motive(opt_name).nil?
# #     end
# # 
# #     def motive(opt_name)
# #       @motives.detect { |m| m.opts.include? opt_name.to_sym }
# #     end
#   end
end
