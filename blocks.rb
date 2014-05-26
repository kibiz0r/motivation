require "pry"

arr = [1, 2, 3]



puts "arr.map do |n|"

r = arr.map do |n|
  puts "n: #{n}"
  if n == 1
    next :first
  end
  yield :whatever
  if n == :done
    break :all_mapped
  end
  n = :done
  redo
end

puts "r: #{r}"

puts "-" * 80

puts "my_map arr do |n|"

def my_map(arr, &block)
  r = []
  arr.each do |n|
    puts "calling #{n}"
    r << block.call(n)
  end
  puts "break out, I dare you!"
  r
end

r = my_map arr do |n|
  puts "n: #{n}"
  if n == 1
    next :first
  end
  if n == :done
    break :all_mapped
  end
  n = :done
  redo
end

puts "r: #{r}"

# Consider this:
#
# def maybe_done(p, n)
#   if n == :done
#     p.break :all_mapped
#   end
# end
# 
# r = my_proposal_map arr do |p, n|
#   puts "n: #{n}"
#   maybe_done p, n
#   p.redo :done
# end

puts "-" * 80

puts "arr.map.each do |n|"

e = arr.map

r = e.each do |n|
  n + 1
end

puts "r: #{r}"



puts "-" * 80

puts "arr.to_enum(:map, &b)"

puts "Let's try to bind the block to the enumerator instead of our use of it..."

b = lambda do |n|
  n + 1
end

e = arr.to_enum(:map, &b)

r = e.each

puts "r: #{r}"



puts "-" * 80

puts "e.next"

puts "Maybe if we iterate it ourselves..."

r1 = e.next
puts "r1: #{r1}"
r2 = e.next
puts "r2: #{r2}"
r3 = e.next
puts "r3: #{r3}"



puts "-" * 80

puts "e.next &b"

puts "Maybe we can at least pass it in on each iteration..."

e = arr.map

r1 = e.next &b
puts "r1: #{r1}"
r2 = e.next &b
puts "r2: #{r2}"
r3 = e.next &b
puts "r3: #{r3}"



puts "-" * 80

puts "arr.map &b (with lambda)"

puts "What's going on here?"
puts "Well, remember that break example?"
puts "It bubbled all the way out of the method, forcing the method to return"
puts "Let's see if we can separate the block from that one"

b = lambda do |n|
  puts "n: #{n}"
  if n == 1
    next :first
  end
  if n == :done
    break :all_mapped
  end
  n = :done
  redo
end

r = arr.map &b

puts "r: #{r}"

puts "Hey, it can't break out!"



puts "-" * 80

puts "arr.map &b (with -> { })"

b = ->(n) {
  puts "n: #{n}"
  if n == 1
    next :first
  end
  if n == :done
    break :all_mapped
  end
  n = :done
  redo
}

r = arr.map &b
puts "r: #{r}"

puts "Same with -> { }"



puts "-" * 80

puts "arr.map &b (with proc)"

b = proc do |n|
  puts "n: #{n}"
  if n == 1
    next :first
  end
  if n == :done
    break :all_mapped
  end
  n = :done
  redo
end

begin
  r = arr.map &b
  puts "r: #{r}"
rescue => e
  puts "raised: #{e}"
end

puts "Oh wow, that one really can't break out!"


puts "-" * 80

puts "So what gives?"

puts "Regular blocks do an early-return on the method they were passed into?"
puts "And Lambdas can break too, but it just acts like it returned a value implicitly or via 'next'?"
puts "But Procs raise when you try to break?"

puts "WTF!"

puts "With all of the variability of the way control statements are handled in blocks,"
puts "it's no surprise that we don't use them more often."

puts "But sometimes, these control statements are really concise ways of expressing some logic"
puts "that we might have a hard time expressing otherwise"

puts "Unfortunately, their use is constrained to single blocks, when so many tasks could benefit from them"
puts "Really, any process that needs an early out -- a way to produce a final value, sure"
puts "but also to produce the value of one iteration, and just move on to the next iteration early"
puts "or to restart the current iteration with different arguments"
puts "or to change the arguments for the next iteration"
puts "or to produce a value for this iteration, and continue here on the next iteration"
puts "or produce a value for this iteration, and continue with a different block on the next iteration"
puts "or just go on to the next iteration"

puts "You should also be able to delegate to another Proposal,"
puts "such that their control statements bubble up to you"
puts "and you can provide blocks to translate arguments from the parent Proposal to child and vice-versa"

puts "You should also be able to change the meaning of the control statements,"
puts "so that when someone finalizes you can do something special"

# Proposal.new do |p, e, &b|
#   e.call p, b
# end
