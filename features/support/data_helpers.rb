def data
  @data ||= {}
end

Around do |scenario, block|
  data.clear
  block.call
  data.clear
end
