module Motivation
  module ContextNode
    def name
      @opts[:name].to_s
    end

    def strict?
      @opts[:strict]
    end

    def path
      @opts[:path]
    end

    def namespaces
      @namespaces.values
    end

    def require
    end

    def auto_scan?
      @opts[:auto_scan]
    end

    def to_hash
      {
        name: name,
        strict: strict?,
        path: path
      }
    end
  end
end
