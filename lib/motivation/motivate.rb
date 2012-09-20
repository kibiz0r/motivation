module Motivation
  module Motivate
    def initialize(*args, &block)
      motivate! *args, &block
      super if defined?(super) && self.class.superclass != Object
    end

    def motivate!(*args, &block)
      opts = args.extract_options!
      self.class.motivated_attr_map.each do |dependency_name, ivar_name|
        instance_variable_set :"@#{ivar_name}", opts[dependency_name]
      end
    end
  end
end
