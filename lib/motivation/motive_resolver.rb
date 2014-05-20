module Motivation
  class MotiveResolver
    # The simple case here is that we're trying to resolve a Motive attached to the root Mote
    #   In that case, we just need to find if there are any MotiveInstances that would prefer to resolve our target Motive
    #   If there are, then we ask the Mote to resolve them (which probably just triggers this same process)
    #     And then we ask the resolved Motive to resolve our target Motive
    #   Otherwise, we just tell it to resolve itself
    #
    # The next case is that we're trying to resolve a Motive attached to a child of the root Mote
    #   We still need to find if there are any Motives that would prefer to resolve us
    #   If there are, then we ask the Mote to resolve them (which probably just triggers this same process)
    #     And then we ask the resolved Motive to resolve our target Motive
    #   Otherwise, we ask the root Mote to resolve our target Motive
    #
    # ---
    #
    # New way, using a MotiveResolution object...
    #
    # Find the next parent of the Motive to resolve, which may be a Mote or
    # Motive.
    # Ask it to handle the MotiveResolution.
    # Use the returned MotiveResolution to decide whether to keep going or
    # return immediately.
    #
    # Maybe we should cut out the definition-checking part. It seems like it
    # would simplify a lot of things if we could just guarantee that all
    # preceding nodes are already reified from the AST.
    #
    # Also, maybe there's a way to use callcc to simplify this? (Or to do it at
    # all...)
    def walk_nodes_from(starting_node)
      Enumerator.new do |yielder|
        yielder.yield starting_node
        starting_node.preceding_nodes.each do |node|
          yielder.yield node
        end
      end
      # return enum_for :walk_nodes_from, starting_node unless block_given?

      # current_mote = starting_node.mote

      # current_mote.scan_preceding_motives(
      #   starting_node.motive
      # ) do |current_motive|
      #   puts "yielding"
      #   yield current_motive
      # end

      # while current_mote = current_mote.parent
      #   current_mote.scan_motives do |current_motive|
      #     puts "yielding"
      #     yield current_motive
      #   end
      # end
    end

    # Something like this?
    def resolve_target(target, args)
      # Each node from the target up to the root will be asked to propose a
      # resolution.
      #
      # The root's proposed resolution will be the final answer, but since each
      # returned resolution should be written in terms of the received one, the
      # target itself really has complete control.
      walk_nodes_from(target).inject lambda { nil } do |resolution, node|
        context = Proposal.new target,
          args,
          on_propose: ->(r) { next r },
          on_final: ->(r) { break r }

        node.propose_resolution context

        resolution
      end.call
    end

    # def resolve_motive(mote, motive, *args)
    #   motive.preceding_nodes.each do |preceding_node|
    #     puts "trying to resolve through #{preceding_node}"
    #     preceding_node.resolve_motive resolution
    #   end

    #   motive.resolve_motive resolution

    #   raise "failed to resolve"


    #   mote.scan_preceding_motive_instances motive.instance do |preceding_motive_instance|
    #     preceding_motive_definition = mote.identify_motive_instance preceding_motive_instance

    #     if preceding_motive_definition.can_resolve_motive_with_definition? motive.definition
    #       preceding_motive = mote.resolve_motive_instance preceding_motive_instance

    #       return preceding_motive.resolve_motive mote, motive, *args
    #     end
    #   end

    #   parent_mote = mote

    #   while parent_mote = parent_mote.parent and parent_mote.can_resolve_motives?
    #     parent_mote.scan_motive_instances do |overriding_motive_instance|
    #       overriding_motive_definition = parent_mote.identify_motive_instance overriding_motive_instance
    #       if overriding_motive_definition.can_resolve_motive_with_definition? motive.definition
    #         overriding_motive = parent_mote.resolve_motive_instance overriding_motive_instance

    #         return overriding_motive.resolve_motive parent_mote, motive, *args
    #       end
    #     end
    #   end

    #   return motive.resolve_self mote, *args
    # end

    def motive_resolution(motive_resolution)
    end
  end
end
