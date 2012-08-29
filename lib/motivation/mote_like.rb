module Motivation
  module MoteLike
    attr_reader :name, :motives, :parent

    def initialize(*args)
      @args = args.extract_options!
      @parent, _ = args

      @name = @args[:name]._? ''
      @motives = @args[:motives]._? []

      @motives.each do |motive|
        extend motive
      end
    end

    def opt(name)
      @args[name]
    end

    def inherited_opt(name, default = nil)
      return default unless parent
      parent.opt(name)._? do
        parent.inherited_opt(name)._? default
      end
    end

    def args
      @args.merge @parent.try(:args)._?({})
    end

    def ==(other)
      name == other.name && parent.equal?(other.parent)
    end
  end
end
