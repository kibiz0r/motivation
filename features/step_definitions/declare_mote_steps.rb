Given /^I have a motefile:$/ do |motefile|
  Motivation.load_string motefile
end

Given /^there is a class "([^"]*)"$/ do |constant_name|
  Object.const_set constant_name, Class.new
end

When /^I locate "([^"]*)"$/ do |to_resolve|
  @last_result = Motivation.send to_resolve
end

When /^I get its constant$/ do
  @last_result = @last_result.constant
end

Then /^I should have the "([^"]*)" class$/ do |class_name|
  @last_result.should == class_name.constantize
end
