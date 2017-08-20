require_relative '../cog'

# must instantiate cog names at top.
room, bob, alice, nicola = nil

def fizzbuzz(n)
  n % 15 == 0 ? 'fizzbuzz' : nil
end

def fizz(n)
  n % 3 == 0 ? 'fizz' : nil
end

def buzz(n)
  n % 5 == 0 ? 'buzz' : nil
end

responses = (1..100).to_a
                    .map{|i| fizzbuzz(i) || fizz(i) || buzz(i) || i.to_s }
                    .freeze


# then instantiate actual cogs
bob = Cog.new(
        read_only: %i[name],
        accessors: %i[name count],
        args: { name: :bob, count: 0 }
      ) { |args| "#{responses[args[:count]]}" }

alice = Cog.new(
          read_only: %i[name],
          accessors: %i[name count],
          args: { name: :alice, count: 0 }
        ) { |args| "#{responses[args[:count]]}" }

nicola = Cog.new(
           read_only: %i[name],
           accessors: %i[name count],
           args: {name: :nicola, count: 0}
         ) { |args| "#{responses[args[:count]]}" }

room = Cog.new(
         args: { players: [bob, alice, nicola].shuffle,
                 count: 0
               }
       ) do |args|
  player = args[:players][args[:count] % 3]
  puts "#{player.name}: #{player.turn}"
  args[:count] += 1
  args[:players].each {|p| p.count = args[:count] }
end


responses.size.times do
  room.turn
  gets
end
