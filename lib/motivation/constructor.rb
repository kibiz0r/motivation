module Motivation
  module Constructor
    def constructor(*dependencies)
      @motivated_attr_map = dependencies.extract_options!
      until dependencies.empty?
        dependency = dependencies.shift
        @motivated_attr_map[dependency] = dependency
      end

      include Motivate
    end

    def motivated_attr_map
      super_attrs = superclass.try(:motivated_attr_map)._?({})
      super_attrs.merge(@motivated_attr_map ||= {})
    end

    def motivated_attrs
      motivated_attr_map.keys
    end
  end

  module Motivate
    def motivate!(*args, &block)
      opts = args.extract_options!
      self.class.motivated_attr_map.each do |dependency_name, ivar_name|
        instance_variable_set :"@#{ivar_name}", opts[dependency_name]
      end
    end

    def initialize(*args, &block)
      motivate! *args, &block
      super if defined?(super) && self.class.superclass != Object
    end
  end
end
