module Motivation
  module Motives
    class NamespaceMotive < Motive
      def initialize(mote, namespace = nil)
        super mote
        @namespace = namespace
      end

      def namespace
        @namespace || ""
      end

      def resolve_target(target, *args) # ResolutionTarget
        case target
        when self
          MotiveResolution.new target, args,
            default: -> { require_source_const namespace }
        when ConstantMotive
        end
      end

      def propose_resolution(resolution, target)
        if target == self
          resolution.propose do
            require_source_const namespace
          end
        end

        if target.is_a? ConstantMotive
          resolution.final do
            self.resolve.const_get target.constant
          end
        end

        if target.is_a? NamespaceMotive
          resolution.final do
            self.resolve.const_get target.namespace
          end
        end

        # resolution.for(self).propose do
        # resolution.for self do
        #   resolution.propose do
        #     require_source_const namespace
        #   end
        # end

        # resolution.for ConstantMotive do |motive|
        #   resolution.final do
        #     self.resolve.const_get motive.constant
        #   end
        # end

        # resolution.for NamespaceMotive do |motive|
        #   resolution.final do
        #     self.resolve.const_get motive.namespace
        #   end
        # end
      end

      def resolve_motive(resolution)
        puts "trying to resolve self #{namespace} (#{self}) vs. #{resolution.target_node}"
        # Trigger this when nobody else can resolve us.
        resolution.for self do
          puts "resolving self"
          resolution.continue do
            require_source_const namespace
          end
        end

        resolution.for ConstantMotive do |motive|
          resolution.return do
            self.resolve.const_get motive.constant
          end
        end

        resolution.for NamespaceMotive do |motive|
          puts "resolving #{motive.namespace}"
          resolution.return do
            self.resolve.const_get motive.namespace
          end
        end
      end

      # def resolve_namespace_motive(mote, namespace_motive, *args)
      #   mote.resolve_motive(self).const_get namespace_motive.namespace(mote)
      # end

      # def resolve_constant_motive(mote, constant_motive, *args)
      #   mote.resolve_motive(self).const_get constant_motive.constant(mote)
      # end
    end
  end
end

