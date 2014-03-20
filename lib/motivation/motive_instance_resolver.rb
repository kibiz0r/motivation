module Motivation
  class MotiveInstanceResolver
    def resolve_motive_instance(motivator, motive_instance)
      # How much should we inspect to try to resolve this?
      #
      # Our goal is to return a new Motive, so we at least need a Mote
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
      definition = motive_instance.parent.resolve_motive_definition motive_instance.name
      mote = motive_instance.parent.resolve
      definition.new mote, *motive_instance.args
    end
  end
end
