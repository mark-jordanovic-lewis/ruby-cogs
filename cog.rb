require 'fiber'

# =====================================================#
#                                                      #
# Inintalize the class instance with two symbol lists  #
# and a hash whose keys are concat of symbol lists.    #
#                                                      #
# The block should take one argument, the hash:        #
#                                                      #
# =====================================================#


class Cog

  attr_reader :readers, :writers

  def initialize(read_only: %i[], accessors: %i[], args: {}, &teeth)
    @writers = accessors - read_only
    @readers = read_only.empty? ? accessors : read_only
    @args = args
    build_cog(&teeth)
    build_readers
    build_writers
  end

  def turn
    @cog.resume
  end

  private

  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      Fiber.yield
      loop do
        Fiber.yield teeth.call(arg_hash)
      end
    end
    @cog.resume(@args)
  end

  def build_writers
    @writers.each do |w|
      define_singleton_method("#{w}=".to_sym) {|var| @args[w] = var }
    end
  end

  def build_readers
    (@readers+@writers).each do |a|
      define_singleton_method(a) { @args[a] }
    end
  end

end
