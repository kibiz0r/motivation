module Motivation
  module Motives
    class ConstantMotive < Motive
      def initialize(constant)
        @constant = constant
      end

      def constant(mote)
        namespace = if mote.respond_to? :namespace
                      mote.namespace
                    end
        mote.require_source_const [namespace, @constant].compact.join("::")
      end
    end
  end
end
