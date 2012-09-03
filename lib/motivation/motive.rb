module Motivation
  module Motives
  end

  module Motive
    attr_accessor :opt_name, :default_value

    def process_opt(mote, opt)
      if default_value.is_a? Proc
        mote.instance_exec &default_value
      else
        default_value
      end
    end

    def self.new(opts, &block)
      opt_name, default = opts.first
      constant_name = opt_name.to_s.camelize :upper

      if Motives.const_defined? constant_name, false
        Motives.const_get constant_name
      else
        Motives.const_set constant_name, Module.new
      end.tap do |mod|
        mod.extend self
        mod.default_value = default
        mod.opt_name = opt_name
        mod.module_eval &block
      end
    end
  end
end
