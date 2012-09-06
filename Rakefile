#!/usr/bin/env rake
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require 'bundler'
Bundler.require
require 'rspec/core/rake_task'
require 'bubble-wrap/motivation'

class Rake::Task
  def delete
    Rake.application.instance_variable_get('@tasks').delete self.name
  end
end

Motion::Project::App.setup do |app|
  app.name = 'motivation'
  app.vendor_project 'vendor/Frank', :static
  app.frameworks += %w(CFNetwork)
end

task(:build).delete
task(:spec).delete

require 'bundler/gem_tasks'

%w(lib).tap do |dirs|
  dirs.each do |dir|
    desc "Run #{dir} specs"
    RSpec::Core::RakeTask.new "spec:#{dir}" do |t|
      t.pattern = "spec/#{dir}/**/*_spec.rb"
    end
  end

  desc "Run ruby specs"
  RSpec::Core::RakeTask.new "spec:ruby" do |t|
    t.pattern = "spec/{#{dirs.join(',')}}/**/*_spec.rb"
  end
end

desc "Run motion specs"
task 'spec:motion' do
  App.config.spec_mode = true
  App.config.specs_dir = "spec/{motion,motion/data}"
  Rake::Task["simulator"].invoke
end

desc "Run all specs"
task :spec => ['spec:ruby', 'spec:motion']

desc "Run all cucumbers"
task :cucumber => 'build:simulator' do
  sh "vendor/bin/cucumber features/"
end

task(:default).delete
task :default => ['spec:ruby', 'cucumber']
