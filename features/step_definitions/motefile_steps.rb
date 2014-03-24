Given /^I have a Motefile:$/ do |body|
  data["Motefile"] = body
end

When /^I require the Motefile$/ do
  Motivation.eval data["Motefile"]
end
