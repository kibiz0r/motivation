require "spec_helper"

describe Proposal do
  # My thought is that this Proposal object must have some sort of final state,
  # because it can't really restart the enumerator. So it must have state along
  # the way, too.
  #
  # Each iteration of a Proposal returns a new Proposal object.
  #
  # The enumerator passed in to the first Proposal is only used until a new
  # Proposal is generated, at which point the new Proposal takes over
  # enumeration. When a Proposal is finalized, it is done enumerating and
  # executes the block that was passed to Proposal#final.
  # describe "#next" do
  #   it "returns the next iteration of the proposal" do
  #   end
  # end

  # describe "#value" do
  #   it "returns the final value of the proposal" do
  #     proposal = Proposal.new [5] do |n, proposal|
  #       proposal.propose do
  #         n * 3
  #       end
  #     end
  #     expect(proposal.value).to eq(15)
  #   end
  # end
  # describe "another crazy world" do
  #   it "looks like this" do
  #     # Managing the body of the Proposal:
  #     # - Proposing pops out of the Proposal block
  #     # - Redoing pops out and starts it again with different args
  #     # - Continuing sets the next Proposal block to use
  #     #
  #     # You can hook into an existing Proposal:
  #     # - before
  #     # - after
  #     # - wrap
  #     #
  #     # The point of a Proposal is that it is invoked once for each value
  #     # passed to #feed, and at every iteration, you are able to:
  #     # - propose a resolution
  #     # - finalize a resolution
  #     # - change the block that is used for future iterations
  #     # - alter the values passed to the block from #feed for future iterations
  #     # -- (this is a special case of changing the block, really)
  #     # - alter potential or existing resolutions
  #     # - simulate more values being inserted into the fed values
  #     #
  #     # When you suggest a resolution, or change the block, the current
  #     # iteration is canceled and the next iteration begins if more fed values
  #     # are available.
  #     #
  #     # ---
  #     #
  #     # The question is how to model Proposals within Proposals.
  #     #
  #     # Suppose the outer Proposal ticks once, delegating to the inner
  #     # Proposal, which generates once tentative Proposition and one final.
  #     #
  #     # The outer Proposal should also generate one tentative and one final.
  #     # This implies that the outer Proposal should actually end up ticking
  #     # twice, but the second time it's actually within the context of the
  #     # inner Proposal already.
  #     #
  #     # I suppose you would need a way to convert the inner Proposition into
  #     # an outer one, because the results likely have different meanings.
  #     #
  #     # But the point is that the execution state is linked. I guess the outer
  #     # Proposal itself takes care of the machinery of proposing/finalizing
  #     # using the conversion block.
  #     map = Proposal.new do
  #     end
  #     [1, 2, 3].proposal.map do |proposal, n|
  #     end

  #     proposal = Proposal.new do |proposal, element|
  #       if element == 1
  #         proposal.propose do
  #           "Hello"
  #         end
  #       end

  #       if element == 2
  #         proposal.after do |s|
  #           "#{s}, World"
  #         end
  #       end
  #     end

  #     proposal = Proposal.new do |proposal, element|
  #       if element == 1
  #         proposal.before do |s|
  #           "Hello, #{s}"
  #         end
  #       end

  #       if element == 2
  #         proposal.propose do
  #           "World"
  #         end
  #       end
  #     end

  #     proposal = Proposal.new do |proposal, element|
  #       if element == 1
  #         proposal.wrap do |p|
  #           "Hello, #{p.value}"
  #           # or?
  #           "Hello, #{p.call}"
  #         end
  #       end

  #       if element == 2
  #         proposal.propose do
  #           "World"
  #         end
  #       end
  #     end

  #     # You can always feed a Proposal more iterations, but it may be finalized
  #     # already. Or, it may never finalize!
  #     proposal.feed(1, 2, 3) do |proposition|
  #       # whether a value was proposed or finalized
  #     end
  #     # or
  #     final_value = proposal.feed(1, 2, 3)
  #   end
  # end

  describe "a sane world" do
    it "looks like this" do
      proposal = Proposal.new do |proposal|
        proposal.propose do
          5
        end
      end
      expect(proposal.call).to eq(5)

      proposal1 = Proposal.new do |p1|
        p1.propose do
          1
        end
      end
      proposal2 = Proposal.new do |p2|
        p2.final do
          2
        end
      end
      proposal3 = Proposal.new do |p3|
        p3.final do
          3
        end
      end
      expect((proposal1 + proposal2 + proposal3).call).to eq(2)

      # proposal = Proposal.new do |proposal|
      #   Proposal.new do |inner|
      #     5
      #   end
      # end
      # expect(proposal.call).to eq(5)

      # proposal = Proposal.new do |proposal|
      #   proposal.continue_with Proposal.new { |inner| 5 }
      #   3
      # end
      # expect(proposal.call).to eq(5)
      # expect(proposal.to_a).to eq([3, 5])

      # When you do Proposition#propose, you are setting a new value_block on
      # it, which will only be evaluated if it is the last value_block set when
      # the Proposal's block finishes.
      #
      # The Proposal's block can use the current Proposition to provide a
      # value_block in terms of the existing value_block, or even to wrap
      # further proposed value_blocks.
      proposal = Proposal.new do |proposal|
        proposal.propose do
          8
        end
        -1
      end
      # The block passed to Proposal.new is used to create a new Proposition,
      # which is set as the next Proposition for the new Proposal.
      #
      # The current Proposition for a new Proposal simply returns nil. It
      # doesn't get yielded in Proposal#each, but it does get passed in to the
      # next Proposition's block, so that if the next Proposition wants to just
      # accept the default value but wants to do something before it gets
      # called, it can wrap the current Proposition.
      #
      # Or maybe the Proposal is responsible for combining them, so that a
      # Proposition only ever talks about itself?
      #
      # The block won't be executed until Proposition#call is invoked, at which
      # point it may implement the return value for Proposal#call, or it may
      # delegate to another Proposition, or set up a next Proposition, etc.
      #
      # When you call Proposal#call, it returns the value of the current
      # Proposition, which may cause the current Proposition to change,
      # or it may just execute and return a value, or it may trigger a chain of
      # Propositions to run in order to return a value, or it may have already
      # been executed so the value is already known and is returned
      # immediately.
      #
      # So, calls with new arguments can be totally ignored if the proposal is
      # already finalized.
      #
      # When you call Proposal#value, it just returns the value of the current
      # proposition.
      expect(proposal.call).to eq(8)
      # expect(proposal.to_a).to eq([8])

      proposal = Proposal.new do |proposal|
        proposal.final do
          5
        end
        proposal.propose do
          19
        end
        raise "hell"
      end

      expect(proposal.call).to eq(5)

      proposal = Proposal.new do |proposal|
        proposal.propose do
          raise "hell"
        end
        proposal.propose do
          21
        end
        :discarded
      end

      expect(proposal.call).to eq(21)
      # expect(proposal.to_a).to eq([5])
    end
  end

  # describe "a crazy world" do
  #   it "looks like this" do
  #     proposal = Proposal.new [1, 2, 3].each do |proposal, n|
  #       puts "proposing"
  #       proposal.propose do
  #         puts "evaluating"
  #         n + 1
  #       end
  #       puts "raising"
  #       # I think this is an important aspect of a Proposal; once made,
  #       # it pops you right out of the method.
  #       raise "hell"
  #     end

  #     puts "getting lazy"
  #     lazy = proposal.each.to_a
  #     puts "calling lazy"
  #     expect(lazy.map(&:call)).to eq([2, 3, 4])
  #     expect(proposal.value).to eq(4)
  #     puts "done"

  #     proposal = Proposal.new [1, 2, 3].each do |proposal, n|
  #       if n == 2
  #         proposal.final do
  #           8
  #         end
  #       else
  #         proposal.propose do
  #           n + 1
  #         end
  #       end
  #     end

  #     expect(proposal.each.to_a.map(&:call)).to eq([2, 8])
  #     expect(proposal.value).to eq(8)

  #     respond = lambda do |proposal, n|
  #       if n == 1
  #         proposal.continue do
  #           n + 1
  #         end
  #       else
  #         proposal.final do
  #           n + 1
  #         end
  #       end
  #     end
  #     proposal = Proposal.new ([respond] * 3).each, 1 do |proposal, responder, n|
  #       responder.call proposal, n
  #     end
  #     expect(proposal.each.to_a.map(&:call)).to eq([3])

  #     proposal = Proposal.new [1, 2, 3].each do |outer, n|
  #       if n == 1
  #         outer.propose do
  #           -n
  #         end
  #       elsif n == 2
  #         outer.propose do
  #           # 2, 20
  #           Proposal.new [n + 1, (n + 1) * 10].each do |inner, n2|
  #             if n2 > 10
  #               inner.final do
  #                 n2 # 20
  #               end
  #             else
  #               inner.propose do
  #                 n2 # 2
  #               end
  #             end
  #           end
  #         end
  #       else
  #         outer.final do
  #           Proposal.new [99, 100, 101] do |finalizer, n2|
  #             if n2 == 101
  #               finalizer.final { n2 }
  #             else
  #               finalizer.propose { n2 }
  #             end
  #           end
  #         end
  #       end
  #     end

  #     # pending "I have no idea what the answer is to this one"
  #     expect(proposal.each.to_a.map(&:call)).to eq([-1, 2, 20, 99, 100, 101])
  #     expect(proposal.value).to eq(101)
  #   end
  # end

  # describe "#final" do
  #   it "can use the initial proposal" do
  #     # I think the Propositions are the things that should contain the state,
  #     # including the enumerator to iterate over. Once proposed, finalized,
  #     # etc., they can't change state. The iteration part of the Proposal can
  #     # inspect that state to decide whether it is done iterating.
  #     proposal = Proposal.new [5, 6] do |n, proposal|
  #       if n == 5
  #         proposal.propose do
  #           "Hello"
  #         end
  #       elsif n == 6
  #         proposal.final do
  #           proposal.value + " World"
  #         end
  #       end
  #     end
  #     expect(proposal.value).to eq("Hello World")
  #   end
  # end
end
