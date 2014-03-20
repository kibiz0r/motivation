module Motivation
  module Motives
    class NamespaceMotive < Motive
      attr_reader :namespace

      def initialize(mote, motive_instance, namespace)
        super mote, motive_instance
        @namespace = namespace
      end

      # def resolve
      #   if self.parent.is_a?(Mote) && self.parent.parent[:namespace]
      #     self.parent.parent[:namespace].resolve_namespace_motive self
      #   else
      #     resolve_self
      #     # self.parent.require_source_const @namespace
      #   end
      # end

      # def resolve_mote
      #   resolve
      # end

      # def resolve_self
      #   # Object.const_get self.namespace
      #   self.parent.require_source_const self.namespace
      # end

      # def resolve_namespace_motive(namespace_motive)
      #   resolve_self.const_get namespace_motive.namespace
      # end
    end
  end
end

