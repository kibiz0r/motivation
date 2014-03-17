module Motivation
  module Motives
    class NamespaceMotive < Motive
      attr_reader :namespace

      def initialize(parent, namespace)
        super parent
        @namespace = namespace
      end

      def resolve
        self.parent.require_source_const @namespace
      end

      def resolve_mote(mote)
        self.resolve
      end

      def resolve_constant_motive(constant_motive)
        self.resolve.const_get constant_motive.constant
      end

      def resolve_namespace_motive(namespace_motive)
        self.resolve.const_get namespace_motive.namespace
      end
    end
  end
end

