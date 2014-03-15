module Motivation
  module Motives
    class NewMotive < Motive
      def new(mote, *args)
        needs_motes = if mote.respond_to? :needs
                  mote.needs
                end
        needs = Array.wrap(needs_motes).map do |need_mote|
          mote.resolve(need_mote).new
        end
        mote.constant.new *needs
      end
    end
  end
end
