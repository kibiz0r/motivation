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
  describe "#next" do
    it "returns the next iteration of the proposal" do
    end
  end

  describe "#value" do
    it "returns the final value of the proposal" do
      proposal = Proposal.new [5] do |n, proposal|
        proposal.propose do
          n * 3
        end
      end
      expect(proposal.value).to eq(15)
    end
  end

  describe "#final" do
    it "can use the initial proposal" do
      # I think the Propositions are the things that should contain the state,
      # including the enumerator to iterate over. Once proposed, finalized,
      # etc., they can't change state. The iteration part of the Proposal can
      # inspect that state to decide whether it is done iterating.
      proposal = Proposal.new [5, 6] do |n, proposal|
        if n == 5
          proposal.propose do
            "Hello"
          end
        elsif n == 6
          proposal.final do
            proposal.value + " World"
          end
        end
      end
      expect(proposal.value).to eq("Hello World")
    end
  end
end
