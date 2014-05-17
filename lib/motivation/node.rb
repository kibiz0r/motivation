module Motivation
  module Node
    def mote
      nil
    end

    def motive
      nil
    end

    def preceding_nodes
      Enumerator.new do |yielder|
        motives.each do |motive|
          yielder.yield motive
        end

        if mote
          yielder.yield mote
        end
      end
    end

    def motives
      if motive
        mote.enum_for :scan_preceding_motives, motive
      else
        mote.enum_for :scan_motives
      end
    end

    def handler
      motive || mote
    end
  end
end
