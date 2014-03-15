module Motivation
  module Motives
    class NamespaceMotive < Motive
      def initialize(namespace)
        @namespace = namespace
      end

      def namespace(mote)
        @namespace.camelize
      end
    end
  end
end

