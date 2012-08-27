module Motivation
  module Constructor
    def constructor(*dependencies)
      @motivated_attrs = dependencies

      define_method :initialize do |args|
        dependencies.each do |dependency|
          instance_variable_set :"@#{dependency}", args[dependency]
        end
      end
    end

    def motivated_attrs
      @motivated_attrs || []
    end
  end
end

