Motivation.motive! factory: lambda { inherited_opt :factory, "#{name}_factory" } do
  def instantiate_factory!
    mote(factory).instantiate!
  end
end
