require "continuation"

module Motivation
  class Proposal
    # attr_reader :target, :args

    # def initialize(target, args, handlers)
    #   @target = target
    #   @args = args || []
    #   @handlers = handlers
    # end
    def initialize(enumerator, &block)
      @enumerator = enumerator.to_enum
      # @target = target
      # @args = args
      @block = block
    end

    # def value(*args)
    #   value = @enumerator.inject -> { nil } do |proposed, context|
    #     proposition = Proposition.new args,
    #       on_propose: ->(p) { proposed = p }

    #     @block.call context, proposition

    #     proposed
    #   end
    #   value.call
    # end
    def value
      each.to_a.last.call
    end

    # def proposition
    #   @proposition ||= Proposition.new
    # end

    def each(&block)
      Enumerator.new do |yielder|
        callcc do |finaled|
          @enumerator.each do |element|
            callcc do |proposed|
              proposition = Proposition.new(
                on_propose: ->(p) { puts "yielding"; yielder.yield p; proposed.call; puts "done yielding" },
                on_final: ->(p) { puts "finaling"; yielder.yield p; finaled.call; puts "done finaling" }
              )
              @block.call element, proposition
            end
          end
        end
      end
    end
    # def each(*args, &block)
    #   return enum_for :each, *args unless block_given?

    #   proposed = -> { nil }
    #   final = false
    #   @enumerator.each do |context|
    #     proposition = Proposition.new args,
    #       on_propose: ->(p) { proposed = p },
    #       on_final: ->(p) { proposed = p; final = true }

    #     block.call proposition

    #     break if final
    #   end
    # end

    def for(target_pattern, *args_pattern, &block)
      if for? target_pattern, *args_pattern
        block.call target, *args
      end
    end

    def for?(target_pattern, *args_pattern)
      if target_pattern.is_a? Class
        if @target.is_a? target_pattern
          true
        end
      elsif @target == target_pattern
        true
      end
    end


    def self.on(enumerable, method, target, *args)
      r = enumerable.inject lambda { nil } do |value, element|
        # Let's encode the iteration mechanism into the Proposal object,
        # so that when you call propose/final, you're actually taking over
        # the iteration.
        state = nil

        proposal = Proposal.new target,
          args,
          on_propose: ->(v) { state = [:next, v] },
          on_final: ->(v) { puts "breaking"; state = [:break, v] }

        puts "asking #{element} to #{method}"
        element.send method, proposal

        if state
          case state.first
          when :next
            next state.last
          when :break
            break state.last
          end
        end

        puts "didn't do anything"
        value
      end.call
      puts "returning from on"
      r
    end

    class Proposition
      def initialize(handlers = {})
        # @args = args
        @handlers = handlers
      end

      def propose(&block)
        if h = @handlers[:on_propose]
          h.call block
        end
      end

      def final(&block)
        if h = @handlers[:on_final]
          h.call block
        end
      end
    end
  end
end
