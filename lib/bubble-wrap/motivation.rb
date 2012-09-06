require 'bubble-wrap/loader'
require 'bubble-wrap/coalesce'
require 'motion_support/all'

BubbleWrap.require 'lib/motivation/**/*.rb' do
  file('lib/motivation/class_ext.rb').depends_on 'lib/motivation/constructor.rb'
  file('lib/motivation/locators/factory.rb').depends_on 'lib/motivation/motivation.rb'
end
