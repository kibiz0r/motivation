module Motivation
  class MoteBlock
    extend Forwardable

    include MoteDsl

    attr_reader :mote_definition

    def_delegators :mote_definition, :add_mote_definition

    def initialize(mote_definition)
      @mote_definition = mote_definition
    end

    def mote_definition!(name, *motives)
      MoteDefinition.new self.mote_definition, name, *motives
    end

    def motive_instance!(name, *args)
      MotiveInstance.new nil, name, *args
    end

    def mote_reference(name)
      MoteReference.new self.mote_definition, name
    end

    def motive_instance_resolvable?(name)
      self.mote_definition.motive_instance_resolvable? name
    end

    def method_missing(method_name, *args, &block)
      name = method_name.to_s
      if invocation = name.end_with?("!")
        name.chop!
      end

      puts "evaling MoteBlock.#{method_name}"

      if invocation
        # north_pole! do
        #   penguin! <-- mote_definition
        # end
        motives = args
        self.mote_definition!(name, *motives).tap do |mote_definition|
          self.add_mote_definition mote_definition
          if block_given?
            # north_pole! do
            #   ice_cap! do
            #     ...
            #   end
            # end
            self.eval_mote_block mote_definition, &block
          end
        end
      elsif self.motive_instance_resolvable? name
        # north_pole! do
        #   elf! constant("Elf") <-- free motive_instance
        # end
        puts "motive_instance #{name}"
        self.motive_instance!(name, *args).tap do |motive_instance|
          if block_given?
            # north_pole! do
            #   namespace "Toys" do
            #     ...
            #   end
            # end
            self.eval_motive_block motive_instance, &block
          end
        end
      else
        # north_pole! do
        #   santa!.needs rudoplh <-- mote_reference
        # end
        validate_mote_name! name
        self.mote_reference name
      end
    end
  end
end
