module Motivation
  module Constructor
    def constructor(*dependencies)
      @motivated_attr_map = dependencies.extract_options!
      until dependencies.empty?
        dependency = dependencies.shift
        @motivated_attr_map[dependency] = dependency
      end

      def initialize(*args, &block)
        motivate! *args, &block
        super if defined?(super) && self.class.superclass != Object
      end
    end

    def motivated_attr_map
      super_attrs = superclass.try(:motivated_attr_map)._?({})
      super_attrs.merge(@motivated_attr_map ||= {})
    end

    def motivated_attrs
      motivated_attr_map.keys
    end
  end
end
