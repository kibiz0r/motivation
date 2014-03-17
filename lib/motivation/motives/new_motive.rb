module Motivation
  module Motives
    class NewMotive < Motive
      def initialize(parent, *args)
        super parent, *args
      end

      def resolve(*args)
        puts "args #{args}"
        self.parent.constant.new *args
      end

      def resolve_mote
        puts "new resolving #{self.parent}"
        resolve *self.args
      end
    end
  end
end
