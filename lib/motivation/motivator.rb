module Motivation
  class Motivator
    attr_accessor :context_resolver,
      :mote_resolver,
      :motive_resolver

    def initialize(*source_modules)
      @source_consts = source_modules.extract_options!
      @source_modules = source_modules

      raise "no source modules" unless source_modules.any?

      [
        :context_resolver,
        :mote_resolver,
        :motive_resolver
      ].each do |resolver|
        instance_variable_set :"@#{resolver}", require_source_const(resolver).new
      end
    end

    def source_const(name)
      source_name = name.to_s.underscore
      const_name = name.to_s.camelize

      return @source_consts[source_name] if @source_consts.has_key? source_name

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
      source_const(name).tap do |const|
        if const.nil?
          const_name = name.to_s.camelize
          or_source_consts = if @source_consts.any?
                               " or source_consts (#{@source_consts.keys.join ", "})"
                             end
          raise "Failed to find constant #{const_name} in source modules (#{@source_modules.join ", "})#{or_source_consts}"
        end
      end
    end

    def motive_defined?(name)
      !source_const("#{name.to_s.camelize}Motive").nil?
    end

    def motive_definition(name)
      require_source_const "#{name.to_s.camelize}Motive"
    end

    def resolve_context_definition(context_definition)
      context_resolver.resolve_definition self, context_definition
    end

    def resolve_mote_definition(context, mote_definition)
      mote_resolver.resolve_mote_definition context, mote_definition
      # mote_resolver.resolve_definition context, mote_definition, *motives
    end

    def resolve_motive_reference(motive_reference)
      motive_resolver.resolve_reference self, motive_reference
    end

    def eval(&block)
      context_definition = ContextDefinition.new(self).tap do |context|
        context.eval &block
      end
      resolve_context_definition context_definition
    end
  end
end
