require_relative 'cog'

class A
  attr_reader :a
  def initialize(a: 'original A class arg')
    @a = a
  end
end

class B
  attr_reader :b
  def initialize(b: 'original B class arg')
    @b = b
  end
end

class C
  attr_reader :c
  def initialize(c: 'original C class arg')
    @c = c
  end
end

class D
  attr_reader :a, :b, :c
  def initialize(a: A.new, b: B.new, c: C.new)
    @a = a
    @b = b
    @c = c
  end
end

d_generator = Cog.new(
  read_only: %i[init],
  accessors: %i[a b c],
  args: {
    init: [ A.new, B.new, C.new ],
    a: A.new,
    b: B.new,
    c: C.new
}) do |args|
  d = D.new(a: args[:a], b: args[:b], c: args[:c])
  args[:a], args[:b], args[:c] = args[:init]
  d
end

#puts d_generator.turn

d_generator.a = A.new(a: 'a was given an arg')
generated_d = d_generator.turn
puts "#{generated_d.a.class}: #{generated_d.a.a}"
puts "#{generated_d.b.class}: #{generated_d.b.b}"
puts "#{generated_d.c.class}: #{generated_d.c.c}"
generated_d = d_generator.turn
puts "#{generated_d.a.class}: #{generated_d.a.a}"
puts "#{generated_d.b.class}: #{generated_d.b.b}"
puts "#{generated_d.c.class}: #{generated_d.c.c}"
