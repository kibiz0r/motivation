Motivation.motive! :singleton, singleton: lambda { inherited_opt :singleton, true } do
  def instantiate!
    @instance ||= super
  end
end
