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
motivation/mote_block.rb
motivation/motive_block.rb
motivation/mote_definition_expression.rb

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
    :new,
    Motivation,
    Motivation::Motives
  ]

  class << self
    attr_writer :motivator

    def motivator
      @motivator ||= Motivator.new
    end

    def method_missing(method_name, *args, &block)
      motivator.send method_name, *args, &block
    end

    def require
      Kernel.require "bubble-wrap"
      REQUIRES.each do |file|
        BW.require "lib/#{file}"
      end
      BW.require "lib/motivation/motion/forwardable.rb"

      File.open "Motefile.motion", "w" do |motion_file|
        motion_file.puts "Motivation::Motion.new \"Motefile\" do"
        File.read("Motefile").each_line do |line|
          motion_file.puts "  #{line}"
        end
        motion_file.puts "end"
      end
      ::Motion::Project::App.setup do |app|
        # app.files += self.files
        app.files << "./Motefile.motion"
        # app.files_dependencies self.file_dependencies
      end
    end

    def eval(string = nil, &block)
      if string
        motivator.eval string
      elsif block_given?
        motivator.eval &block
      end

      self
    end
  end
end
