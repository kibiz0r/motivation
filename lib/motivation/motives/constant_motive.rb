module Motivation
  module Motives
    class ConstantMotive < Motive
      def initialize(constant)
        @constant = constant
      end

      def resolve(mote)
        # namespace = if mote.respond_to? :namespace
        #               mote.namespace.name.demodulize
        #             end
        # mote.require_source_const [namespace, @constant].compact.join("::")
        mote.require_source_const @constant
      end
    end
  end
end
