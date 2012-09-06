When /^I get the file dependency graph$/ do
  @last_result = Motivation.file_dependencies
end

Then /^I should see the following file dependencies:$/ do |file_dependencies|
  @last_result.should == Hash[file_dependencies.rows_hash.map do |file, dependencies|
    [file, dependencies.split(/,\s*/)]
  end]
end
