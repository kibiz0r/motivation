#!/usr/bin/env rake
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require 'bundler'
Bundler.require :default, :development, :motion
require 'rspec/core/rake_task'
require 'motivation'
require 'motion_support/all'

class Rake::Task
  def delete
    Rake.application.instance_variable_get('@tasks').delete self.name
  end
end

Motion::Project::App.setup do |app|
  app.name = 'motivation'
  app.files += Dir['lib/motivation/**/*.rb']
end

task(:build).delete
task(:spec).delete

require 'bundler/gem_tasks'

%w(lib motion).tap do |dirs|
  dirs.each do |dir|
    desc "Run #{dir} specs"
    RSpec::Core::RakeTask.new "spec:#{dir}" do |t|
      t.pattern = "spec/#{dir}/**/*_spec.rb"
    end
  end

  desc "Run all specs"
  RSpec::Core::RakeTask.new "spec" do |t|
    t.pattern = "spec/{#{dirs.join(',')}}/**/*_spec.rb"
  end
end
