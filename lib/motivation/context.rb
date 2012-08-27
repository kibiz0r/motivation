module Motivation
  class Context
    DEFAULT_PATH_ROOT = 'lib'
    DEFAULT_OPTS = { auto_scan: true }

    include Motivation::ContextNode

    attr_reader :path

    def initialize(&block)
      @motes = {}
      @namespaces = {}
      motivation
      Motivation::Context.current = self
      if block_given?
        Motivation::ContextLoader.new(self).instance_exec &block
      end
    end

    def motivation(*args)
      @opts = DEFAULT_OPTS.merge args.extract_options!
      @path = args[0] || DEFAULT_PATH_ROOT
    end

    def path_for(object)
      mote(object).path
    end

    def files
      motes.map &:path
    end

    def dependencies
      {}
    end

    def allow_require?
      true
    end

    def require
      if allow_require?
        @motes.each do |name, mote|
          unless mote.motion
            mote.require
          end
        end
      end
      self
    end

    def namespace!(name, opts = {}, &block)
      namespace_opts = @opts.merge(name: name, path: File.join(path, name.to_s)).merge opts
      @namespaces[name] = Motivation::Namespace.new(namespace_opts, &block).tap do |namespace|
        namespace.motes.each do |mote|
          add_mote mote
        end
      end
    end

    def mote!(name, *args)
      # TODO: okay to override name?
      opts = args.extract_options!
      class_name = args[0] || name
      mote_opts = @opts.merge(name: name, class_name: class_name, path: File.join(path, class_name.to_s)).merge opts
      add_mote Motivation::Mote.new(mote_opts)
    end

    def add_mote(mote)
      @motes[mote.name.to_sym] = mote
    end      

    def namespaces
      @namespaces.values
    end

    def motes
      @motes.values
    end

    def [](name)
      mote(name).try :factory
    end

    def self.[](name)
      current[name]
    end

    def instantiate(name)
      if name.end_with? '_factory'
        name = name.gsub(/_factory$/, '') unless self[name]
        self[name]
      else
        factory = self[name]

        if factory.motivated_attrs.size > 0
          filled_dependencies = Hash[factory.motivated_attrs.map do |dep|
            [dep, instantiate(dep)]
          end]
          factory.new filled_dependencies
        else
          factory.new
        end
      end
    end

    def self.instantiate(name)
      current.instantiate name
    end

    def mote(name)
      @motes[name.to_sym]
    end

    class << self
      attr_accessor :current
      def files; current.files; end
      def dependencies; current.dependencies; end
    end
  end
end
