Given /^I have a module "([^"]+)":$/ do |module_name, body|
  Module.new.tap do |mod|
    Object.const_reset module_name, mod
    mod.class_eval body, __FILE__, __LINE__
  end
end
