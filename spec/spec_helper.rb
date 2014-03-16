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
