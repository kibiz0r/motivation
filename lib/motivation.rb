require "active_support/all"
require "coalesce"
require "motivation/motivation"

Motivation::Requires.each do |file|
  require file
end
