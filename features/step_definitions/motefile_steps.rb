Given /^I have a Motefile:$/ do |body|
  data["Motefile"] = body
end

When /^I require the Motefile$/ do
  data["root"] = Motivation::Motefile.eval data["Motefile"]
end
