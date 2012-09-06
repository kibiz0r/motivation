module Motivation
  module Constructor
    def constructor(*dependencies)
      @motivated_attr_map = dependencies.extract_options!
      until dependencies.empty?
        dependency = dependencies.shift
        @motivated_attr_map[dependency] = dependency
      end

      define_method :initialize do |args|
        self.class.motivated_attr_map.each do |ivar_name, dependency_name|
          instance_variable_set :"@#{ivar_name}", args[dependency_name]
        end
      end
    end

    def motivated_attr_map
      @motivated_attr_map ||= {}
    end

    def motivated_attrs
      motivated_attr_map.values
    end
  end
end
