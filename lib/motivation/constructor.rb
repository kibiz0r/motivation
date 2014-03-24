module Motivation
  module Constructor
    def constructor(*constructor_args)
      @constructor_args = constructor_args
      define_singleton_method :new do |*new_args|
        raise "Wrong number of arguments to new -- expected #{@constructor_args.size}, got #{new_args.size}"
        constructor_args.zip new_args do |constructor_arg, new_arg|
          instance_variable_set :"@#{constructor_arg}", new_arg
        end
      end
    end
  end
end

# module Motivation
#   module Constructor
#     def constructor(*dependencies)
#       my_motivated_attr_map.merge! dependencies.extract_options!
# 
#       until dependencies.empty?
#         dependency = dependencies.shift
#         my_motivated_attr_map[dependency] = dependency
#       end
# 
#       include Motivation::Motivate
#     end
# 
#     def motivated_attr_map
#       super_attrs = superclass.try(:motivated_attr_map)._?({})
#       super_attrs.merge my_motivated_attr_map
#     end
# 
#     def motivated_attrs
#       motivated_attr_map.keys
#     end
# 
#     private
#     def my_motivated_attr_map
#       @motivated_attr_map ||= {}
#     end
#   end
# end
