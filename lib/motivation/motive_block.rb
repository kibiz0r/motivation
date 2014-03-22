module Motivation
  class MotiveBlock
    include MoteDsl

    attr_reader :mote_definition, :motives

    def initialize(motivator, mote_definition, *motive_instances)
      @motivator = motivator
      @mote_definition = mote_definition
      @motives = motive_instances
    end

    def to_s
      "MotiveBlock(#{self.motives})"
    end

    def ==(other)
      other.is_a?(MotiveBlock) &&
        self.mote_definition == other.mote_definition &&
        self.motives == other.motives
    end

    def add_mote_definition(mote_definition)
      @motivator.mote_definition_adder.add_mote_definition @motivator, @mote_definition, mote_definition
    end

    def mote_definition_expression(mote_definition)
      MoteDefinitionExpression.new @motivator, mote_definition
    end

        # north_pole! do
        #   namespace "Reindeer" do
        #     constant "Vixen" do
        #     end
        #   end
        # end
    def method_missing(method_name, *args, &block)
      name = method_name.to_s
      if invocation = name.end_with?("!")
        name.chop!
      end

      if invocation
        # namespace "NorthPole" do
        #   santa! <-- mote_definition
        # end
        motives = self.motives.map(&:dup) + args
        mote_definition = self.mote_definition! name, *motives
        self.add_mote_definition mote_definition
        if block_given?
          # namespace "NorthPole" do
          #   ice_cap! do
          #     ...
          #   end
          # end
          self.eval_mote_block mote_definition, &block
        end
        self.mote_definition_expression mote_definition
      else
        # parent_mote! do
        #   namespace "Foo" do
        #     constant "Bar" do
        #     end
        #   end
        #
        #   namespace "Blurgle" do
        #     my_mote! constant("Eek")
        #   end
        # end
        if self.motive_instance_resolvable? name
          self.motive_instance!(name, *args).tap do |motive_instance|
            if block_given?
              self.eval_motive_block motive_instance, &block
            end
          end
        else
          validate_mote_name! name
          self.mote_reference name
        end
      end
    end      
  end
end
