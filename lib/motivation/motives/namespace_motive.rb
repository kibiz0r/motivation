module Motivation
  module Motives
    class NamespaceMotive < Motive
      def initialize(motive_instance, namespace = nil)
        super motive_instance
        @namespace = namespace
      end

      def namespace(mote)
        @namespace || ""
      end

      def resolve_self(mote)
        mote.require_source_const namespace(mote)
      end

      def resolve_namespace_motive(mote, namespace_motive, *args)
        mote.resolve_motive(self).const_get namespace_motive.namespace(mote)
      end

      def resolve_constant_motive(mote, constant_motive, *args)
        mote.resolve_motive(self).const_get constant_motive.constant(mote)
      end
    end
  end
end

