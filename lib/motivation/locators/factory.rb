Motivation.locator! /(.*)_factory$/ do |mote_name|
  mote(mote_name).try :pseudo, name: "#{mote_name}_factory", instantiated: false
end
