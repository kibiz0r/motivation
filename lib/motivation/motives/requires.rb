Motivation.motive! :requires, requires: [] do
  def required_motes
    Array.wrap(opt(:requires)).map do |required_mote|
      mote(required_mote)
    end
  end

  def required_mote_files
    required_motes.map do |required_mote|
      required_mote.require_method :file, from: "Requires#required_mote_files"
    end
  end
end
