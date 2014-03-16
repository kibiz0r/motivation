module Motivation
  module Motives
    class NamespaceMotive < Motive
      def initialize(namespace)
        @namespace = namespace
      end

      def resolve(mote)
        mote.require_source_const @namespace
      end
    end
  end
end

