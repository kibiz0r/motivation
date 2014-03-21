module Motivation
  class MotiveResolver
    def resolve_reference(motivator, motive_reference)
      motive_class = motivator.motive_definition motive_reference.name
      motive_class.new(*motive_reference.args).tap do |motive|
        motive.args = motive_reference.args
      end
    end

    def resolve_motive_reference(mote, motive_reference)
      mote.motivator.motive_definition(motive_reference.name).new mote, *motive_reference.args
    end

    def resolve_motive(mote, motive, *args)
      if mote_definition = motive.instance.parent
        # find the earliest match for this motive, and starting there...
        motives = mote_definition.motives
        starting_index = motives.find_index do |motive_instance|
          motive_instance == motive.instance
        end  || motives.size

        # scan backwards through motive instances for something that resolves this motive definition
        overriding_motive_instance = mote_definition.motives[0...starting_index].reverse_each.find do |motive_instance|
          motive_definition(mote, motive_instance).can_resolve_motive_with_definition? motive.definition
        end

        if overriding_motive_instance
          puts "overriding resolution of #{motive} with #{overriding_motive_instance}"
          overriding_motive = mote.resolve_motive_instance overriding_motive_instance
          overriding_motive.resolve_namespace_motive mote, motive
        elsif mote.parent.is_a? Mote
          puts "resolving motive via parent mote"
          resolve_motive mote.parent, motive
        else
          puts "Telling #{motive} to resolve itself"
          binding.pry
          motive.resolve_self mote
        end
      else
        motive.resolve_self *args
      end
    end

    private

    def motive_definition(mote, motive_instance)
      mote.resolve_motive_definition_name motive_instance.name
    end
  end
end
