module Motivation
  class MotiveResolution
    attr_reader :target_node,
      :resolution_args

    def initialize(target_node, resolution_args, resolution_handlers = {})
      @target_node = target_node
      @resolution_args = resolution_args
      @resolution_handlers = resolution_handlers
    end

    def return(&block)
      resolution = MotiveResolution.new target_node, resolution_args,
        @resolution_handlers.merge(value: block)
      @resolution_handlers[:return].call resolution
    end

    def continue(&block)
      resolution = MotiveResolution.new target_node, resolution_args,
        @resolution_handlers.merge(value: block)
      @resolution_handlers[:continue].call resolution
    end

    def value
      @resolution_handlers[:value].call *resolution_args
    end

    def for(target_pattern, &block)
      puts "#{target_node} vs #{target_pattern}"
      if target_pattern.is_a? Class
        puts "#{target_pattern} is a Class"
        if target_node.is_a? target_pattern
          block.call target_node
        end
      elsif target_node == target_pattern
        puts "#{target_node} == #{target_pattern}"
        block.call
      end
    end
  end

  class Resolution
    def initialize(&block)
      @block = block
    end

    def value
      @block.call
    end
  end
end
