module Motivation
  class Motivator
    extend Forwardable

    Resolvers = %w|
    mote_resolver
    mote_value_resolver
    motive_resolver
    mote_definition_resolver
    mote_reference_resolver
    motive_instance_resolver
    mote_definition_adder
    |.map &:to_sym

    attr_reader :root_mote,
      :source_constant_resolver,
      *Resolvers

    def_delegators :source_constant_resolver,
      :require_source_const,
      :source_const,
      :source_const?

    def root_mote_definition
      unless @root_mote_definition
        motivation
      end
      @root_mote_definition
    end

    def source_modules
      unless @source_modules
        motivation
      end
      @source_modules
    end

    def eval(string = nil, &block)
      if string
        MoteBlock.new(self, root_mote.definition).eval string
      elsif block_given?
        MoteBlock.new(self, root_mote.definition).eval &block
      end
      self
    end

    def motivation(*args)
      if args.empty?
        args = DefaultMotivationArgs
      end

      root_mote_definition_spec = args.slice! 0, args.find_index { |a| a.is_a? Module } || 0
      motive_instances = root_mote_definition_spec.map do |motive_instance_spec| 
        Motive.instance *motive_instance_spec
      end
      @root_mote_definition = Mote.define nil, *motive_instances
      @source_consts = Hash[args.extract_options!.map { |k, v| [k.to_sym, v] }]
      @source_modules = args

      self
    end

    def initialize
    end

    Resolvers.each do |resolver|
      define_method :"#{resolver}" do
        instance_variable_get :"@#{resolver}" or
          instance_variable_set :"@#{resolver}", require_source_const(resolver).new
      end
    end

    def source_constant_resolver
      @source_constant_resolver ||= SourceConstantResolver.new @source_modules, @source_consts
    end

    def motivator
      self
    end

    def root_mote
      @root_mote ||= Mote.new self, root_mote_definition
    end

    def resolve_mote_definition(mote_definition)
      if mote_definition == root_mote.definition
        return root_mote
      end
      mote_definition_resolver.resolve_mote_definition self, mote_definition
    end

    # def resolve_motive_instance(motive_instance)
    #   if mote = resolve_mote_definition(motive_instance.parent)
    #     motive_instance_resolver.resolve_motive_instance mote, motive_instance
    #   end
    # end

    def resolve_motive(motive, *args)
      # motive.resolve_self root_mote, *args
    end

    def can_resolve_motives?
      false
    end

    def can_resolve_mote_definitions?
      false
    end

    def can_find_mote_definitions?
      false
    end

    def can_resolve_motes?
      false
    end

    def resolve_motive_instance_definition(motive_instance)
      resolve_motive_definition_name motive_instance.name
    end

    # motive_instance_identifiable?
    def motive_definition_name_resolvable?(motive_definition_name)
      source_const? "#{motive_definition_name}_motive"
    end

    def identify_motive_instance(motive_instance)
      require_source_const("#{motive_instance.name}_motive")
    end

    def motive_instance_identifier
      require_source_const(:motive_instance_identifier).new
    end

    def motive_instance_finder
      require_source_const(:motive_instance_finder).new
    end

    def mote_definition_finder
      require_source_const(:mote_definition_finder).new
    end

    def mote_value_resolver
      require_source_const(:mote_value_resolver).new
    end

    def [](mote_name)
      root_mote[mote_name]
    end

    # def method_missing(method_name, *args, &block)
    #   root_mote.send method_name, *args, &block
    # end

    # def motive_defined?(name)
    #   !source_const("#{name.to_s.camelize}Motive").nil?
    # end

    # def motive_definition(name)
    #   require_source_const "#{name.to_s.camelize}Motive"
    # end

    # def resolve_context_definition(context_definition)
    #   context_resolver.resolve_definition self, context_definition
    # end

    # def resolve_mote_definition(context, mote_definition)
    #   mote_resolver.resolve_mote_definition context, mote_definition
    #   # mote_resolver.resolve_definition context, mote_definition, *motives
    # end

    # def resolve_motive_reference(motive_reference)
    #   motive_resolver.resolve_reference self, motive_reference
    # end

    # def eval(&block)
    #   context_definition = ContextDefinition.new(self).tap do |context|
    #     context.eval &block
    #   end
    #   resolve_context_definition context_definition
    # end
  end
end
