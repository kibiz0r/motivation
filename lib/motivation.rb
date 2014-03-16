require "active_support/all"
require "coalesce"
require "motivation/motivation"

Motivation::REQUIRES.each do |file|
  require file
end
