# -*- encoding: utf-8 -*-
require File.expand_path("../lib/motivation/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "motivation"
  gem.description   = "Motivation helps you painlessly define your object graph for DI and the RubyMotion build system through convention"
  gem.homepage      = "https://github.com/kibiz0r/#{gem.name}"
  gem.version       = Motivation::VERSION

  gem.authors       = ["Michael Harrington"]
  gem.email         = ["kibiz0r@gmail.com"]

  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "bubble-wrap"
  gem.add_runtime_dependency "motion-support", "~> 0.2.6"
  gem.add_runtime_dependency "activesupport"
  gem.add_runtime_dependency "coalesce"
  gem.add_development_dependency "rspec-core"
  gem.add_development_dependency "rspec-expectations"
  gem.add_development_dependency "rr"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "ruby-prof"

  gem.summary       = <<-END.gsub(/^ +/, "")
    Motivation allows you to define your object graph according to your own
    conventions, automatically construct objects according to their dependencies,
    and track file dependencies for more efficient RubyMotion compilation.
  END
end
