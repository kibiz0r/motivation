require 'bundler'
Bundler.require :default, :test
$LOAD_PATH << Dir.pwd
require 'rspec'
require 'active_support/all'
require 'motivation'

RSpec.configure do |config|
  config.mock_with :rr
end

def raise_opt_error(*args)
  raise_error Motivation::MoteOptError, Motivation::MoteOptError.message(*args)
end

def raise_method_error(*args)
  raise_error Motivation::MoteMethodError, Motivation::MoteMethodError.message(*args)
end
