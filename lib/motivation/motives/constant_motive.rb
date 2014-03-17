module Motivation
  module Motives
    class ConstantMotive < Motive
      attr_reader :constant

      def initialize(parent, constant)
        super parent
        @constant = constant
      end

      def resolve
        self.parent.require_source_const @constant
      end
    end
  end
end
