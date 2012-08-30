module Motivation
  module Motives
  end

  module Motive
    def self.new(opts, &block)
      opt_name, default = opts.first
      constant_name = opt_name.to_s.camelize :upper

      if Motives.const_defined? constant_name, false
        Motives.const_get constant_name
      else
        Motives.const_set constant_name, Module.new
      end.tap do |mod|
        mod.module_eval do
          include ::Motivation::Motive

          define_method opt_name do
            specified_opt(opt_name)._? do
              if default.is_a? Proc
                instance_exec &default
              else
                default
              end
            end
          end

          define_method "#{opt_name}=" do |val|
            specify opt_name, val
          end

          define_singleton_method :opt_name do
            opt_name
          end

          module_eval &block
        end
      end
    end
  end
end
