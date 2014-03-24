def mote_definition(parent, name, *motives)
  Motivation::Mote.define parent, name, *motives
end

def mote!(parent, definition, *motives)
  Motivation::Mote.new parent, definition, *motives
end

def mote_reference(parent, name)
  Motivation::MoteReference.new parent, name
end

def motive_reference(parent, name, *args)
  Motivation::Motive.reference parent, name, *args
end

class Module
  def const_reset(name, value)
    remove_const name if const_defined? name
    const_set name, value
  end
end
