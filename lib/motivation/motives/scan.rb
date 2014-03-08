# Motivation.motive! :scan, scan: lambda { File.join opt(:path), '*.rb' } do
#   def on_container
#     super
#     Dir[opt(:scan)].each do |file|
#       mote_name = File.basename file, '.rb'
#       mote! mote_name
#     end
#   end
# end
