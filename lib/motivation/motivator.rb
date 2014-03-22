module Motivation
  class Motivator
    extend Forwardable

    Resolvers = %w|
    mote_resolver
    motive_resolver
    mote_definition_resolver
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

    # def_delegators :root_mote, :[], :eval
    def eval(&block)
      MoteBlock.new(self, root_mote.definition).eval &block
      self
    end

    def initialize(root_mote_definition, *source_modules, &eval_block)
      source_consts = Hash[source_modules.extract_options!.map { |k, v| [k.to_sym, v] }]
      source_modules = source_modules

      @source_constant_resolver = SourceConstantResolver.new source_modules, source_consts

      Resolvers.each do |resolver|
        instance_variable_set :"@#{resolver}", require_source_const(resolver).new
      end

      @root_mote = Mote.new self, root_mote_definition

      self.eval &eval_block if block_given?
    end

    def motivator
      self
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
      motive.resolve_self root_mote, *args
    end

    def resolve_motive_instance_definition(motive_instance)
      resolve_motive_definition_name motive_instance.name
    end

    def find_mote_definition(mote_definition_name)
      nil
    end

    def find_motive_instance(motive_instance_name)
      nil
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

    def [](mote_name)
      root_mote[mote_name]
    end

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
