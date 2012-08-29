Motivation.resolver! /(.*)_factory$/ do |name|
  mote(name).pseudo name: "#{name}_factory", instantiated: false
end
