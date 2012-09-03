module Motivation
  class Mote
    attr_reader :name

    def initialize(*args)
      @opts = args.extract_options!
      @name = @opts.delete(:name)._? ''
      motives = @opts.delete(:motives)._? []

      @motives = Hash[motives.map do |motive|
        extend motive
        [motive.opt_name.to_sym, motive]
      end]
    end

    def opt(opt_name)
      specified_opt(opt_name)._? { motive_opt(opt_name) }
    end

    def require_opt(opt_name, raise_opts = {})
      raise_unless_opt opt_name, raise_opts
      opt opt_name
    end

    def require_method(method_name, raise_opts = {})
      raise_unless_method method_name, raise_opts
      send method_name
    end

    def args
      @opts
    end

    def raise_unless_method(method_name, opts = {})
      return if respond_to? method_name
      raise MoteMethodError.new method_name, opts
    end

    def raise_unless_opt(opt_name, opts = {})
      return if opt? opt_name
      raise MoteOptError.new opt_name, opts
    end

    def resolve!
      require_method :constant, from: 'Mote#resolve!'
    end

    private
    def specified_opt(opt_name)
      @opts[opt_name.to_sym]
    end

    def motive_opt(opt_name)
      motive(opt_name).try :process_opt, self, opt_name
    end

    def opt?(opt_name)
      @opts.has_key?(opt_name.to_sym) || motive?(opt_name)
    end

    def motive?(opt_name)
      @motives.has_key? opt_name.to_sym
    end

    def motive(opt_name)
      @motives[opt_name.to_sym]
    end
  end
end
