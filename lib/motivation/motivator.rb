module Motivation
  class Motivator
    extend Forwardable

    Resolvers = %w|
    mote_resolver
    motive_resolver
    mote_definition_resolver
    motive_instance_resolver
    |.map &:to_sym

    attr_reader :root_mote_definition, *Resolvers

    # def_delegators :root_mote, :[], :eval
    def eval(&block)
      self.root_mote_definition.eval &block
      self
    end

    def initialize(root_mote_definition, *source_modules, &eval_block)
      @source_consts = Hash[source_modules.extract_options!.map { |k, v| [k.to_sym, v] }]
      @source_modules = source_modules

      raise "no source modules" unless @source_modules.any?

      Resolvers.each do |resolver|
        instance_variable_set :"@#{resolver}", require_source_const(resolver).new
      end

      @mote_definitions = {}

      (@root_mote_definition = root_mote_definition).parent = self

      self.eval &eval_block if block_given?
    end

    def motivator
      self
    end

    def resolve_mote_definition(mote_definition)
      self.mote_definition_resolver.resolve_mote_definition self, mote_definition
    end

    def resolve_motive_instance(motive_instance)
      self.motive_instance_resolver.resolve_motive_instance self, motive_instance
    end

    def resolve_motive_definition(motive_name)
      self.require_source_const("#{motive_name}_motive")
    end

    def resolve_motive(motive, *args)
      self.motive_resolver.resolve_motive self, motive, *args
    end

    def [](mote_name)
      mote_name = mote_name.to_sym
      if mote_definition = @mote_definitions[mote_name]
        self.resolve_mote_definition mote_definition
      else
        raise "No such mote: #{mote_name}"
      end
    end

    def add_mote_definition(mote_definition)
      puts "add_mote_definition"
      mote_name = mote_definition.name.to_sym
      @mote_definitions[mote_name] = mote_definition
    end

    def source_const?(name)
      !source_const(name).nil?
    end

    def source_const(name)
      source_name = name.to_s.underscore
      source_sym = source_name.to_sym

      const_name = name.to_s.camelize

      return @source_consts[source_sym] if @source_consts.has_key? source_sym

      @source_modules.each do |source_module|
        const = const_name.split("::").inject source_module do |module_part, const_part|
          if module_part && module_part.const_defined?(const_part)
            module_part.const_get const_part
          end
        end
        if const
          return const
        end
      end

      nil
    end

    def require_source_const(name)
      self.source_const(name).tap do |const|
        if const.nil?
          const_name = name.to_s.camelize
          or_source_consts = if @source_consts.any?
                               " or source_consts (#{@source_consts.keys.join ", "})"
                             end
          raise "Failed to find constant #{const_name} in source modules (#{@source_modules.join ", "})#{or_source_consts}"
        end
      end
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
