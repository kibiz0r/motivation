require "bundler"
Bundler.require :default, :test, :development, :cucumber
require "motivation"

RubyProf.start

at_exit do
  results = RubyProf.stop
  File.open "tmp/profile-graph.html", 'w' do |file|
    RubyProf::GraphHtmlPrinter.new(results).print(file)
  end 

  File.open "tmp/profile-flat.txt", 'w' do |file|
    RubyProf::FlatPrinter.new(results).print(file)
  end 
end 

# UIQuery is deprecated. Please use the shelley selector engine. 
# Frank::Cucumber::FrankHelper.use_shelley_from_now_on

# TODO: set this constant to the full path for your Frankified target's app bundle.
# See the "Given I launch the app" step definition in launch_steps.rb for more details
# APP_BUNDLE_PATH = File.expand_path 'build/iPhoneSimulator-5.1-Development/motivation.app'
