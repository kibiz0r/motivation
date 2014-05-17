module Motivation
  module Motives
  end

  Requires = %w|
motivation/motivation.rb
motivation/version.rb

motivation/mote_dsl.rb
motivation/mote_definition.rb
motivation/mote_reference.rb
motivation/motive_reference.rb
motivation/motive_instance.rb
motivation/motefile_block.rb
motivation/mote_block.rb
motivation/motive_block.rb
motivation/mote_definition_expression.rb

motivation/node.rb
motivation/motive_resolution.rb
motivation/mote_resolver.rb
motivation/mote_value_resolver.rb
motivation/motive_resolver.rb
motivation/mote_definition_resolver.rb
motivation/mote_reference_resolver.rb
motivation/motive_instance_resolver.rb
motivation/motive_instance_identifier.rb
motivation/source_constant_resolver.rb
motivation/motive_instance_finder.rb
motivation/mote_definition_finder.rb
motivation/mote_definition_adder.rb

motivation/motivator.rb
motivation/motefile.rb
motivation/mote.rb
motivation/motive.rb

motivation/motives/constant_motive.rb
motivation/motives/namespace_motive.rb
motivation/motives/new_motive.rb
motivation/motives/needs_motive.rb
motivation/motives/project_motive.rb
motivation/motives/context_motive.rb
motivation/motives/value_motive.rb
motivation/motives/template_motive.rb
motivation/motives/singleton_motive.rb

motivation/constructor.rb
motivation/class_ext.rb
|

  DefaultMotivationArgs = [
    :context,
    :namespace,
    :constant,
    :singleton,
    :new,
    Motivation,
    Motivation::Motives
  ]

  class << self
    attr_accessor :root

    def method_missing(method_name, *args, &block)
      root.send method_name, *args, &block
    end

    def require(motefile = "Motefile")
      # This should just be
      # root = Motefile.eval motefile

      # But for now...
      Kernel.require "bubble-wrap"
      REQUIRES.each do |file|
        BW.require "lib/#{file}"
      end
      BW.require "lib/motivation/motion/forwardable.rb"

      File.open "#{motefile}.motion", "w" do |motion_file|
        motion_file.puts "Motivation::Motion.new \"#{motefile}\" do"
        File.read(motefile).each_line do |line|
          motion_file.puts "  #{line}"
        end
        motion_file.puts "end"
      end
      ::Motion::Project::App.setup do |app|
        # app.files += self.files
        app.files << "./#{motefile}.motion"
        # app.files_dependencies self.file_dependencies
      end
    end
  end
end
