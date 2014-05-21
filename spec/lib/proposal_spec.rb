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
  describe "another crazy world" do
    it "looks like this" do
      Proposal.new do |proposal, element|
        if element == 1
          proposal.continue do
            "Hello"
          end
        end

        if element == 2
          proposal.propose do |s|
            "#{s}, World"
          end
        end
      end
      proposal.through([1, 2, 3]).value
    end
  end

  describe "a crazy world" do
    it "looks like this" do
      proposal = Proposal.new [1, 2, 3].each do |proposal, n|
        puts "proposing"
        proposal.propose do
          puts "evaluating"
          n + 1
        end
        puts "raising"
        # I think this is an important aspect of a Proposal; once made,
        # it pops you right out of the method.
        raise "hell"
      end

      puts "getting lazy"
      lazy = proposal.each.to_a
      puts "calling lazy"
      expect(lazy.map(&:call)).to eq([2, 3, 4])
      expect(proposal.value).to eq(4)
      puts "done"

      proposal = Proposal.new [1, 2, 3].each do |proposal, n|
        if n == 2
          proposal.final do
            8
          end
        else
          proposal.propose do
            n + 1
          end
        end
      end

      expect(proposal.each.to_a.map(&:call)).to eq([2, 8])
      expect(proposal.value).to eq(8)

      respond = lambda do |proposal, n|
        if n == 1
          proposal.continue do
            n + 1
          end
        else
          proposal.final do
            n + 1
          end
        end
      end
      proposal = Proposal.new ([respond] * 3).each, 1 do |proposal, responder, n|
        responder.call proposal, n
      end
      expect(proposal.each.to_a.map(&:call)).to eq([3])

      proposal = Proposal.new [1, 2, 3].each do |outer, n|
        if n == 1
          outer.propose do
            -n
          end
        elsif n == 2
          outer.propose do
            # 2, 20
            Proposal.new [n + 1, (n + 1) * 10].each do |inner, n2|
              if n2 > 10
                inner.final do
                  n2 # 20
                end
              else
                inner.propose do
                  n2 # 2
                end
              end
            end
          end
        else
          outer.final do
            Proposal.new [99, 100, 101] do |finalizer, n2|
              if n2 == 101
                finalizer.final { n2 }
              else
                finalizer.propose { n2 }
              end
            end
          end
        end
      end

      # pending "I have no idea what the answer is to this one"
      expect(proposal.each.to_a.map(&:call)).to eq([-1, 2, 20, 99, 100, 101])
      expect(proposal.value).to eq(101)
    end
  end

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
