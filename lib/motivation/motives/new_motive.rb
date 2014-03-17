module Motivation
  module Motives
    class NewMotive < Motive
      def initialize(parent)
        super parent
      end

      def resolve(*args)
        self.parent.constant.new *args
      end

      def resolve_mote(mote)
        resolve
      end

      # def resolve_mote(mote)
      #   needs_motes = if mote.respond_to? :needs
      #             mote.needs
      #           end
      #   needs = Array.wrap(needs_motes).map do |need_mote|
      #     mote.resolve_mote_reference(need_mote).resolve
      #   end
      #   mote.constant.new *needs
      # end

      # def resolve
      #   needs_motes = if mote.respond_to? :needs
      #             mote.needs
      #           end
      #   needs = Array.wrap(needs_motes).map do |need_mote|
      #     mote.resolve_mote_reference(need_mote).resolve
      #   end
      #   mote.constant.new *needs
      # end
    end
  end
end
