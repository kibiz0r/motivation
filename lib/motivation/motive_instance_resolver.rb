module Motivation
  class MotiveInstanceResolver
    def resolve_motive_instance(mote, motive_instance)
      # How much should we inspect to try to resolve this?
      #
      # Our goal is to return a new Motive, so we at least need a Mote
      # (That is maybe not true, as we could resolve it through the MotiveInstance)
      # That means that we must resolve the MotiveInstance's parent
      # And we must know what Motive class to use
      #
      # Because MoteDefinitions can map a MotiveClass...
      #   e.g. my_mote! module_name: namespace("Foo")
      # ...we must consult it to find out our definition
      #
      # But MoteDefinitions can delegate to MotiveInstances,
      # so that means that we must find the definition of every MotiveInstance before us
      # and instantiate them if they implement #resolve_motive_instance
      #
      # -------
      #
      # This should eventually live in Motivator.propose_resolution for
      # MotiveInstance, and should resolve the args before passing them.
      #
      # Maybe this is a different verb, for turning the AST Nodes into Nodes...
      # Maybe propose_instantiation?
      # Or maybe this is two steps: first identifying the definition, then
      # instantiating it?
      if definition = mote.identify_motive_instance(motive_instance)
        begin
          definition.new mote, *motive_instance.args
        rescue ArgumentError => e
          raise ArgumentError, "#{mote}.#{motive_instance}(#{motive_instance.args.join ", "}): #{e}"
        end
      end
    end
  end
end
