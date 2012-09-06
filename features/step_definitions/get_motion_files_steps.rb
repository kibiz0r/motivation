When /^I get the file list$/ do
  @last_result = Motivation.files
end

Then /^I should see the following files:$/ do |files|
  @last_result.should == files.split("\n")
end
