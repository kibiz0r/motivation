Motivation.motive! :namespace, namespace: true  do
  def constant_name
    "#{namespace}::#{opt :constant_name}"
  end

  def namespace
    case opt :namespace
    when true
      if self.is_a? Motivation::Container
        "#{parent.try :namespace}::#{name.camelize :upper}"
      else
        parent.try(:namespace)._? { p parent; p self; '' }
      end
    when false
      parent.try(:namespace)._? ''
    else
      opt :namespace
    end
  end
end
