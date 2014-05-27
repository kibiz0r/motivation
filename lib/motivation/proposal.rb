require "continuation"

module Motivation
  class Proposal
    # attr_reader :target, :args

    # def initialize(target, args, handlers)
    #   @target = target
    #   @args = args || []
    #   @handlers = handlers
    # end

    include Enumerable

    def initialize(&block)
      # @current = Proposition.new(
      #   on_continue: ->(p) { @current = p },
      #   &block
      # )
      @block = block
    end

    def next
      @next.call @current
    end

    def each
      return enum_for :each unless block_given?

      result = @current.call Proposition.new

      yield result

      if result.is_a? Proposal
        result.each do |r|
          yield r
        end
      end

      nil
    end

    def call(*args)
      current = Proposition.new
      return_value = @block.call current, *args
      current.default { return_value }
      current.value

      # continuation = nil
      # result = @block.call Proposition.new(
      #   on_continue_with: ->(p) { continuation = p }
      # )

      # if result.is_a? Proposal
      #   return result.call
      # end

      # if continuation
      #   return continuation.call
      # end

      # result
    end

    class Proposition
      def initialize(handlers = {}, &block)
        @handlers = handlers
        @block = block
        @value_block = nil
      end

      def continue_with(proposal)
        if handler = @handlers[:on_continue_with]
          handler.call proposal
        end

        nil
      end

      def continue
        if handler = @handlers[:on_continue]
          handler.call self
        end

        nil
      end

      def propose(&value_block)
        # @value_block = value_block

        if handler = @handlers[:on_propose]
          handler.call value_block
        end

        nil
      end

      def has_value?
        !@value.nil? || !@value_block.nil?
      end

      def value
        # This will re-call @value_block if it returns nil...
        if @value.nil? && !@value_block.nil?
          @value = @value_block.call
        else
          @value
        end
      end

      def call(*args)
        return value if has_value?

        final_block = callcc do |cc|
          @handlers[:on_propose] = lambda do |value_block|
            @value_block = value_block
          end
          @handlers[:on_final] = cc
          return_value = @block.call self, *args
          @value = return_value unless has_value?
          nil
        end

        @value_block = final_block unless has_value?

        return value if has_value?
      end

      def final(&value_block)
        # @value_block = value_block

        if handler = @handlers[:on_final]
          handler.call value_block
        end

        nil
      end

      def default(&value_block)
      end
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

    # def each(&block)
    #   args = @args
    #   Enumerator.new do |yielder|
    #     callcc do |finaled| # Can be simulated with throw/catch.
    #       @enumerator.each do |element|
    #         callcc do |proposed|
    #           proposition = Proposition.new(
    #             on_propose: ->(p) { puts "yielding"; yielder.yield p; proposed.call; puts "done yielding" },
    #             on_final: ->(p) { puts "finaling"; yielder.yield p; finaled.call; puts "done finaling" },
    #             on_continue: ->(a) { args = a.call; puts "continuing with #{args}"; proposed.call }
    #           )
    #           puts "calling with #{args}"
    #           @block.call proposition, element, *args
    #         end
    #       end
    #     end
    #   end
    # end
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

    # class Proposition
    #   def initialize(handlers = {})
    #     # @args = args
    #     @handlers = handlers
    #   end

    #   def propose(&block)
    #     if h = @handlers[:on_propose]
    #       h.call block
    #     end
    #   end

    #   def final(&block)
    #     if h = @handlers[:on_final]
    #       h.call block
    #     end
    #   end

    #   def continue(&block)
    #     if h = @handlers[:on_continue]
    #       h.call block
    #     end
    #   end
    # end
  end
end
