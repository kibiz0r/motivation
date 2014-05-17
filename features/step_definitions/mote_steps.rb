MotePhrase = Transform /the (resolved|Mote) "([^"]+)"/ do |mote_getter, mote_name|
  send(:"get_#{mote_getter}", mote_name).tap do |mote|
    expect(mote).to be
  end
end

ShouldPhrase = Transform /should (resolve to an instance of|be an instance of|respond to|have) (?:"([^"]+)"|(\d+) (\w+))/ do |matcher_string, string_arg, have_size, have_property|
  case matcher_string
  when "resolve to an instance of"
    lambda do |value|
      value.resolve.tap do |resolved|
        expect(resolved).to be_an_instance_of(string_arg.constantize)
      end
    end
  when "be an instance of"
    lambda do |value|
      value.tap do |v|
        expect(v).to be_an_instance_of(string_arg.constantize)
      end
    end
  when "respond to"
    lambda do |value|
      expect(value).to respond_to(string_arg)
      value.send string_arg
    end
  when "have"
    lambda do |value|
      expect(value).to have(have_size.to_i).send(have_property)
      value.send have_property
    end
  else
    raise "hell"
  end
end

MoteClause = Transform /(#{MotePhrase}) (#{ShouldPhrase})/ do |mote_string, should_block_string|
  mote = Transform mote_string
  should_block = Transform should_block_string
  should_block.call mote
end

SubClause = Transform /, (each of which|which) (#{ShouldPhrase})/ do |clause_type, should_block_string|
  should_block = Transform should_block_string
  case clause_type
  when "which"
    should_block
  when "each of which"
    lambda do |value|
      value.each &should_block
    end
  else
    raise "hell"
  end
end

Then /^(#{MoteClause})(#{SubClause})?$/ do |mote_clause_value, sub_clause_block|
  if sub_clause_block
    sub_clause_block.call mote_clause_value
  end
end

# Then /^the instance "([^"]+)" should have "([^"]+)" instances of "([^"]+)"$/ do |instance_name, matcher_argument, element_type|
#   match = have(matcher_argument.to_i).send :"#{element_type.demodulize.pluralize}"
#   expect(instance(instance_name)).to match
#   mote.each { |e| expect(e).to be_an_instance_of(element_type.constantize) }
# end

def get_Mote(mote_name)
  data["root"][mote_name]
end

def get_resolved(mote_name)
  get_Mote(mote_name).resolve
end
