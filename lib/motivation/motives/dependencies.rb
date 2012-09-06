Motivation.motive! :dependencies, dependencies: lambda { load_dependencies! } do
  def load_dependencies!
    if is_mote?
      Hash[require_method(:constant).motivated_attrs.map do |attr|
        [attr, attr]
      end]
    else
      {}
    end
  end

  def resolve_dependencies!
    Hash[opt(:dependencies).map do |dep_name, mote_name|
      begin
        [dep_name, resolve_mote!(mote_name)]
      rescue => e
        raise "Failed to resolve dependency '#{dep_name}': #{e}"
      end
    end]
  end
end
