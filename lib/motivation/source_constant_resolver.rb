module Motivation
  class SourceConstantResolver
    def initialize(source_modules, source_consts)
      @source_modules = source_modules
      @source_consts = source_consts

      raise "no sources available" unless @source_modules.any? || @source_consts.any?
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
  end
end
