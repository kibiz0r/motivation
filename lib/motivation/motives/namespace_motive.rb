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

      def resolve_mote
        resolve
      end

      def resolve_constant_motive_reference(motive_reference)
        constant_name = motive_reference.args.first
        constant = [self.namespace, constant_name].compact.join "::"
        ConstantMotive.new self.parent, constant
      end
    end
  end
end

