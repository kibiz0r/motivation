Motivation.motive! instantiated: lambda { inherited_opt :instantiated, 'new' } do
  def instantiate!
    return constant unless instantiated
    instantiate_factory!.send instantiated, instantiate_dependencies!
  end
end
