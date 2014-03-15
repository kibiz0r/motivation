module Motivation
  def self.require
    File.open "Motefile.motion", "w" do |motion_file|
      motion_file.puts "Motivation::Motion.new do"
      File.read("Motefile").each_line do |line|
        motion_file.puts "  #{line}"
      end
      motion_file.puts "end"
    end
    Motion::Project::App.setup do |app|
      # app.files += self.files
      app.files << "./Motefile.motion"
      # app.files_dependencies self.file_dependencies
    end
  end
end
