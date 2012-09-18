module Motivation
  module Motivate
    def motivate!(*args, &block)
      opts = args.extract_options!
      self.class.motivated_attr_map.each do |dependency_name, ivar_name|
        instance_variable_set :"@#{ivar_name}", opts[dependency_name]
      end
    end
  end
end
