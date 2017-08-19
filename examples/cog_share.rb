require_relative '../cog'

# Have to define cogs at top

alice, bob = nil

bob = Cog.new(accessors: %i[has], args: {has: 10}) do |args|
  if alice.has < args[:has]
    puts "Here, take one Alice."
    alice.has = alice.has + 1
    args[:has] -= 1
    puts "Now I have #{args[:has]}"
  else
    puts "We both have equal"
  end
end

alice = Cog.new(accessors: %i[has], args: {has: 0}) do |args|
  if args[:has] < bob.has
    puts "I have #{args[:has]} can I have some more?"
  else
    puts "Thanks Bob."
  end
end


room = Cog.new(read_only: %i[bob alice], args: {bob: bob, alice: alice} ) do |args|
  args[:bob].turn
  args[:alice].turn
end


puts "To begin with Bob has #{room.bob.has} and Alice has #{room.alice.has}."
puts
puts "Now we will go turn buy turn through the cogs"
count = 0

while room.bob.has > room.alice.has
  puts "\t\t Turn #{count+=1}"
  puts "\t\t========"
  room.turn
  puts
end
