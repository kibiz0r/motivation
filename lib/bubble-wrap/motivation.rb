require 'bubble-wrap/loader'

BubbleWrap.require 'lib/motivation/**/*.rb' do
  file('lib/motivation/class_ext.rb').depends_on 'lib/motivation/constructor.rb'
  file('lib/motivation/context.rb').depends_on 'lib/motivation/context_node.rb'
  file('lib/motivation/namespace.rb').depends_on 'lib/motivation/context_node.rb'
end
