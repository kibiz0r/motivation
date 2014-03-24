Then /^the Mote "([^"]+)" should resolve to "([^"]+)"$/ do |mote_name, constant_name|
  expect(Motivation[mote_name].resolve).to eq(constant_name.constantize)
end
