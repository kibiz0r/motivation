module Motivation
  class MotefileBlock
    extend Forwardable

    def_delegators :motivator,
      :root_mote,
      :root_mote_block,
      :root_mote_definition

    def eval(string = nil, &block)
      if string
        self.instance_eval string, __FILE__, __LINE__
      elsif block_given?
        self.instance_eval &block
      end

      root_mote
    end

    def motivation(*args)
      if args.empty?
        args = DefaultMotivationArgs
      end

      @motivator = Motivator.new *args
    end

    def motivator
      @motivator || motivation
    end

    def method_missing(method_name, *args, &block)
      root_mote_block.send method_name, *args, &block
    end
  end
end
