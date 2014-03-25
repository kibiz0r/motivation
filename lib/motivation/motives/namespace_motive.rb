module Motivation
  module Motives
    class NamespaceMotive < Motive
      attr_reader :namespace

      def initialize(motive_instance, namespace)
        super motive_instance
        @namespace = namespace
      end

      def resolve_self(mote)
        mote.require_source_const namespace
      end

      def resolve_namespace_motive(mote, namespace_motive, *args)
        mote.resolve_motive(self).const_get namespace_motive.namespace
      end
    end
  end
end

