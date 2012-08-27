require 'bundler'
Bundler.require :default, :test
$LOAD_PATH << Dir.pwd
require 'rspec'
require 'active_support/all'
require 'motivation'

RSpec.configure do |config|
  config.mock_with :rr
end

