Motivation.motive! constant: lambda { } do
  def constant
    raise_unless_opt :constant_name
    opt(:constant_name).constantize
  end
end
