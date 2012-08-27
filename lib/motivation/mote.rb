module Motivation
  class Mote
    def initialize(opts)
      @opts = { factory: opts[:class_name] }.merge opts # TODO: vulnerable to mutability
    end

    def name
      @opts[:name].to_s
    end

    def strict
      @opts[:strict]
    end

    def path
      @path ||= if @opts[:path].end_with? '.rb'
                  @opts[:path]
                else
                  "#{@opts[:path]}.rb"
                end
    end
    
    def factory
      @klass ||= load_factory
    end

    def motion
      @opts[:motion]
    end

    def require
      super path unless motion
    end

    def load_factory
      require
      @opts[:factory].to_s.classify.constantize
    end

    def ==(other)
      @opts == other.instance_variable_get(:@opts)
    end

    def dependencies
      factory.motivated_attrs
    end

    def to_hash
      {
        name: name,
        path: path,
        dependencies: dependencies
      }
    end
  end
end
