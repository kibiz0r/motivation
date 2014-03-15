module Motivation
  module Motives
    class NeedsMotive < Motive
      def initialize(*needs)
        @needs = needs
      end

      def needs(mote)
        @needs
      end
    end
  end
end
