Motivation.motive! :constant, constant_name: lambda { name.camelize :upper } do
  def constant_name
    opt(:constant_name).to_s
  end

  def constant
    constant_name.safe_constantize
  end

  def resolve!(*args)
    constant._? { super }
  end
end
