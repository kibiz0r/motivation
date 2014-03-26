Then /^the Mote "([^"]+)" should resolve to "([^"]+)"$/ do |mote_name, constant_name|
  expect(Motivation[mote_name].resolve).to be_a(constant_name.constantize)
end

Then /^the instance "([^"]+)" should expose "([^"]+)", which is ([^"]+) "([^"]+)"$/ do |mote_name, property_name, matcher_string, matcher_argument|
  match = send :"be_#{matcher_string.gsub(" ", "_")}", matcher_argument.constantize
  mote = Motivation[mote_name].resolve
  expect(mote).to be
  expect(mote.send(property_name)).to match
end

Then /^the instance "([^"]+)" should ([^"]+) "([^"]+)" of "([^"]+)"$/ do |mote_name, matcher_string, matcher_argument, element_type|
  match = send(:"#{matcher_string.gsub(" ", "_")}", matcher_argument.to_i).send :"#{element_type.demodulize.pluralize}"
  mote = Motivation[mote_name].resolve
  expect(mote).to be
  expect(mote).to match
  expect(mote.first).to be_an_instance_of(element_type.constantize)
end
