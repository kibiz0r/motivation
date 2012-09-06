module Motivation
  class << self
    def motives
      @motives._? { @motives = [] }
    end

    def locators
      @locators._? { @locators = [] }
    end

    def root
      @root._? { @root = '.' }
    end

    attr_writer :motives, :root

    def motive!(*args, &block)
      motives << Motive.new(*args, &block)
    end

    def locator!(*args, &block)
      locators << Locator.new(*args, &block)
    end

    def reset!
      self.motives = nil
      self.root = nil
    end

    def context!(opts = {})
      default_opts = { motives: motives, locators: locators, path: root }
      Context.new default_opts.merge(opts)
    end

    def files
      Context.current.files
    end

    def file_dependencies
      Context.current.file_dependencies
    end

    def method_missing(mote_name, *args, &block)
      mote_name = mote_name.to_s
      if mote_name.end_with? '!'
        mote_name.chop!
        Context.current.resolve_mote! mote_name, *args, &block
      else
        Context.current.locate_mote mote_name, *args, &block
      end
    end

    def require(motefile = 'Motefile')
      MoteLoader.new(context!(name: motefile)).require motefile
    end

    def load_string(str)
      MoteLoader.new(context!).load_string str
    end

    def motion!
      File.open 'Motefile.motion', 'w' do |motion_file|
        motion_file.puts 'Motivation::Motion.new do'
        File.read('Motefile').each_line do |line|
          motion_file.puts "  #{line}"
        end
        motion_file.puts 'end'
      end
      Motion::Project::App.setup do |app|
        app.files += self.files
        app.files << './Motefile.motion'
        app.files_dependencies self.file_dependencies
      end
    end
  end
end

