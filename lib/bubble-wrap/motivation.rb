require 'bubble-wrap/loader'

BubbleWrap.require 'lib/motivation/**/*.rb' do
  # file('lib/motivation/foo.rb').depends_on 'lib/motivation/bar.rb'
  file('lib/motivation/container.rb').depends_on 'lib/motivation/mote_like.rb'
  file('lib/motivation/mote.rb').depends_on 'lib/motivation/mote_like.rb'
end
