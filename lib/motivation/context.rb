module Motivation
  class Context
    attr_reader :motivator, :definition

    def initialize(motivator, definition)
      @motivator = motivator
      @definition = definition
      @motes = {}
    end

    def resolve_mote_definition(mote_definition, *motives)
      motivator.resolve_mote_definition self, mote_definition, *motives
    end

    def resolve_mote_reference(mote_reference)
      name = mote_reference.name
      mote = self[name]
      return mote if mote
      raise "No such mote: #{mote_reference} motes: #{@motes}"
    end

    def resolve_motive_reference(motive_reference)
      motivator.resolve_motive_reference motive_reference
    end

    def [](name)
      name = name.to_sym

      return @motes[name] if @motes.has_key? name

      mote_definition = definition.motes.find do |mote|
        mote.name == name
      end

      # TODO: Check for ambiguous mote_definition

      # motives = mote_definition.motives.map do |motive_reference|
      #   resolve_motive_reference motive_reference
      # end
      resolve_mote_definition(mote_definition).tap do |mote|
        @motes[name] = mote
      end
    end
  end
end
