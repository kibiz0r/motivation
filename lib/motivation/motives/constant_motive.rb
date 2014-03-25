module Motivation
  module Motives
    class ConstantMotive < Motive
      def initialize(motive_instance, constant = nil)
        super motive_instance
        @constant = constant
      end

      def constant(mote)
        binding.pry if mote.name.nil?
        @constant || mote.name.classify
      end

      def resolve_self(mote, *args)
        mote.require_source_const constant(mote)
      end
    end
  end
end
