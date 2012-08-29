Motivation.motive! lazy: lambda { inherited_opt :lazy, false } do
  def prepare!
    super unless lazy
  end

  def constant
    return super unless lazy
    super._? { require!; super }
  end
end
