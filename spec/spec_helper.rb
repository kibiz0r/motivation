require "bundler"
Bundler.require :default, :test, :development
require "motivation"
Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rr
end

include Motivation
include Motivation::Motives

def mote_definition(name, *motives)
  MoteDefinition.new context_definition, name, *motives
end

def mote!(name, *motives)
  Mote.new mote_definition(name, *motives)
end

def mote_reference(name)
  MoteReference.new context_definition, name
end

def motive_reference(name, *args)
  MotiveReference.new context_definition, name, *args
end

def motive_block(motive)
  MotiveBlock.new context_definition, motive
end

class Module
  def const_reset(name, value)
    remove_const name if const_defined? name
    const_set name, value
  end
end

def test_module(name, &block)
  let name do
    Module.new.tap do |mod|
      block.call mod
      const_name = name.to_s.camelize
      Object.const_reset const_name, mod
    end
  end
end
