require 'bubble-wrap/loader'

BubbleWrap.require 'lib/motivation/**/*.rb' do
  # file('lib/motivation/foo.rb').depends_on 'lib/motivation/bar.rb'
end
