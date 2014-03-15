require "active_support/all"
require "coalesce"

%w|
motivation/version.rb
motivation/mote_dsl.rb
motivation/motivation.rb
motivation/mote.rb
motivation/context.rb
motivation/motion.rb
motivation/motive.rb
motivation/context_definition.rb
motivation/mote_definition.rb
motivation/mote_reference.rb
motivation/motive_reference.rb
motivation/motive_block.rb
motivation/mote_block.rb
motivation/context_resolver.rb
motivation/mote_resolver.rb
motivation/motive_resolver.rb
motivation/motivator.rb
motivation/motives/constant_motive.rb
motivation/motives/namespace_motive.rb
motivation/motives/new_motive.rb
motivation/motives/needs_motive.rb
motivation/motives/project_motive.rb
|.each do |file|
  require file
  BW.require "lib/#{file}" if defined? BW
end
