module Motivation
  module Motives
    class TemplateMotive < Motive
      attr_reader :template_mote_reference

      def initialize(motive_instance, template_mote_reference)
        super motive_instance
        @template_mote_reference = template_mote_reference
      end
    end
  end
end
