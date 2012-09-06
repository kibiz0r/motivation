Motivation.motive! :instantiated, instantiated: lambda { inherited_opt :instantiated, 'new' } do
  def resolve!
    return constant unless opt :instantiated
    instantiate!
  end

  def instantiate!
    factory = require_method :resolve_factory!, from: 'Instantiated#instantiate!'
    dependencies = require_method :resolve_dependencies!, from: 'Instantiated#instantiate!'
    if dependencies.empty?
      factory.send opt(:instantiated)
    else
      factory.send opt(:instantiated), dependencies
    end
  end
end
