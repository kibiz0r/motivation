module Motivation
  def self.require(motefile = './Motefile')
    Motivation::Context.current = Motivation::ContextLoader.require motefile
  end

  def self.namespaces
    Motivation::Context.current.namespaces
  end

  def self.motes
    Motivation::Context.current.motes
  end

  def self.method_missing(mote, *args, &block)
    mote = mote.to_s
    instantiate = mote.end_with? '!'
    mote = mote.gsub '!', ''

    if instantiate
      Motivation::Context.instantiate mote
    else
      Motivation::Context[mote]
    end
  end
end
