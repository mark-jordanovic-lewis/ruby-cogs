require_relative 'cog'

# must instantiate cog names at top.
room, bob, alice, nicola = nil

def fizzbuzz?(n)
  n % 15 == 0 ? 'fizzbuzz' : n.to_s
end

def fizz?(n)
  n % 3 == 0 ? 'fizz' : n.to_s
end

def buzz?(n)
  n % 5 == 0 ? 'buzz' : n.to_s
end

reposnses = (1..101).to_a.map(&:fizzbuzz?).map(&:fizz?).map(&:buzz?).freeze


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
         args: { players: [bob, alice, nicola].shuffle }
       ) do |args|
  count = 0
  player = args[:players][count % 3]
  puts "#{player.read(:name)}: #{player.turn}"
  count += 1
  args[:players].each {|p| p.write(:count, count) }
end


responses.size.times do
  room.turn
  gets
end
