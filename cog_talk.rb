require_relative 'cog'

# Have to define cogs at top

alice, bob = nil

bob = Cog.new(accessors: %i[has], args: {has: 10}) do |args|
  if alice.has < args[:has]
    puts "Here, take one Alice."
    alice.write(:has, alice.read(:has) + 1)
    args[:has] -= 1
    puts "Now I have #{args[:has]}"
  else
    puts "We both have equal"
  end
end

alice = Cog.new(accessors: %i[has], args: {has: 0}) do |args|
  if args[:has] < bob.read(:has)
    puts "I have #{args[:has]} can I have some more?"
  else
    puts "Thanks Bob."
  end
end


room = Cog.new(readers: %i[bob alice], args: {bob: bob, alice: alice} ) do |args|
  args[:bob].turn
  args[:alice].turn
end


puts "To begin with Bob has #{room.read(:bob).read(:has)} and Alice has #{room.read(:alice).read(:has)}."
puts
puts "Now we will go turn buy turn through the cogs"
count = 0

while room.read(:bob).read(:has) > room.read(:alice).read(:has)
  puts "\t\t Turn #{count+=1}"
  puts "\t\t========"
  room.turn
  puts
end
