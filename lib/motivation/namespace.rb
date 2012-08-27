module Motivation
  class Namespace
    DEFAULT_OPTS = { strict: false }
    include Motivation::ContextNode

    def initialize(opts, &block)
      @opts = opts
      @motes = {}
      if block_given?
        if auto_scan?
          scan!
        end
        Motivation::ContextLoader.new(self).instance_exec &block
      end
    end

    def scan!(glob = "#{self.path}/*.rb")
      Dir[glob].map do |file|
        mote! File.basename(file, '.rb')
      end
    end

    def motes
      @motes.values
    end

    def mote!(name, class_name = name, opts = {})
      # TODO: okay to override name?
      mote_opts = @opts.merge(name: name, class_name: class_name, path: File.join(path, class_name.to_s)).merge opts
      @motes[name] = Motivation::Mote.new mote_opts
    end

    def ==(other)
      @opts == other.instance_variable_get(:@opts)
    end
  end
end
