Motivation.motive! opaque: lambda { inherited_opt :opaque, false } do
  def can_require?
    !opaque && super
  end
end
