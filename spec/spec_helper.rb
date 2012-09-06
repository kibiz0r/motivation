require 'bundler'
Bundler.require :default, :test
$LOAD_PATH << Dir.pwd
require 'rspec'
require 'active_support/all'
require 'motivation'
Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rr
end

def raise_opt_error(opt_name, raise_opts = {})
  merged_raise_opts = { included_motives: [], defined_motives: [] }.merge raise_opts
  raise_error Motivation::MoteOptError, Motivation::MoteOptError.message(opt_name, merged_raise_opts)
end

def raise_method_error(method_name, raise_opts = {})
  merged_raise_opts = { included_motives: [], defined_motives: [] }.merge raise_opts
  raise_error Motivation::MoteMethodError, Motivation::MoteMethodError.message(method_name, merged_raise_opts)
end
