module Motivation
  attr_reader :motives

  def self.motive!(*args, &block)
    @motives ||= []
    @motives << Motive.new(*args, &block)
  end

  def self.resolver!(*args, &block)
    @resolvers ||= []
    @resolvers << Resolver.new(*args, &block)
  end

  def self.method_missing(*args, &block)
    p args
    puts caller.join("\n")
    Context.current.resolve! *args, &block
  end

  def self.require
    MoteLoader.new(Context.new).require 'Motefile'
  end
end

class Object
  def _?(x = nil)
    self
  end
end

class NilClass
  def _?(x = nil)
    if block_given?
      yield
    else
      x
    end
  end
end

class Class
  def init_attr(attrs)
    attrs.each do |attr, default|
      ivar = :"@#{attr}"
      define_method attr do
        instance_variable_get(ivar)._? { instance_variable_set(ivar, default.dup) }
      end
    end
  end
end
