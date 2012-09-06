module Motivation
  class Container
    # include MoteLike

    attr_reader :name, :parent, :motives, :context

    def initialize(*args)
      @containers = {}
      @opts = args.extract_options!
      @name = @opts.delete(:name).to_s
      @parent = @opts.delete(:parent)
      @context = @opts.delete(:context)
      @motes = Hash[@opts.delete(:motes)._?([]).map do |mote|
        [mote.name, mote]
      end]
      @motives = @opts.delete(:motives)._? []

      @motives.each do |motive|
        extend motive
      end
    end

    def is_mote?
      false
    end

    def opt(opt_name)
      specified_opt(opt_name)._? { motive_opt(opt_name) }
    end

    def container!(*args)
      opts = args.extract_options!
      container_name, _ = args
      container_name = container_name._? opts.delete(:name)

      Motivation::Container.new(self, opts.merge(name: container_name, parent: self, context: context, motives: motives)).tap do |container|
        @containers[container_name.to_sym] = container if container_name
        container.on_container
      end
    end

    def container(container_name)
      @containers[container_name.to_sym]
    end

    def containers
      @containers.values
    end

    def on_container
    end

    def mote!(*args)
      opts = args.extract_options!
      mote_name, _ = args
      mote_name = mote_name._? opts.delete(:name)

      Motivation::Mote.new(self, opts.merge(name: mote_name, parent: self, context: context, motives: motives)).tap do |mote|
        @motes[mote_name.to_sym] = mote if mote_name
      end
    end

    def mote(mote_name)
      all_motes[mote_name.to_sym]
    end

    def all_motes
      top_container.motes
    end

    def top_container
      top = self
      until top.parent.nil?
        top = top.parent
      end
      top
    end

    def motes
      containers.inject(@motes.dup) do |sub_motes, container|
        sub_motes.merge container.motes
      end
    end

    def resolve_mote!(mote, *args)
      context.try :resolve_mote!, mote, *args
    end

    def inherited_opt(opt_name, default = nil)
      parent.try(:opt, opt_name.to_sym)._? default
    end

    def ==(other)
      name == other.name && parent.equal?(other.parent)
    end

    private
    def specified_opt(opt_name)
      @opts[opt_name.to_sym]
    end

    def motive_opt(opt_name)
      motive(opt_name).try :process_opt, self, opt_name
    end

    def motive(opt_name)
      @motives.detect { |m| m.opts.include? opt_name.to_sym }
    end
  end
end
