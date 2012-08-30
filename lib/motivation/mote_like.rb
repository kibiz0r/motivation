module Motivation
  module MoteLike
    attr_reader :name, :motives, :parent, :specified_opts

    def initialize(*args)
      @specified_opts = args.extract_options!
      @parent, _ = args

      @name = specified_opts[:name]._? ''
      @motives = specified_opts[:motives]._? []

      motives.each do |motive|
        extend motive
      end
    end

    def opt(name)
      opts[name]
    end

    def opts
      specified_opts
    end

    def motive_opts
      Hash[@motives.map do |motive|
        [motive.opt_name, send(motive.opt_name)]
      end]
    end

    def specify(opt, value)
      @specified_opts[opt] = value
    end

    def specified_opt(opt)
      specified_opts[opt]
    end

    def inherited_opt(name, default = nil)
      parent.try(:opt, name)._? default
    end

    def ==(other)
      parent.equal?(other.parent) && opts == other.opts
    end
  end
end
