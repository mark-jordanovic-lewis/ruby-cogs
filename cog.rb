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
  end

  def turn
    @cog.resume
  end

  def read(arg)
    @readers.include?(arg) ? @args[arg] : raise(ReadDisallowed)
  end

  def write(arg, val)
    @writers.include?(arg) ? @args[arg] = val : raise(WriteDisallowed)
  end

  private

  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      Fiber.yield
      loop do
        teeth.call(arg_hash)
        Fiber.yield
      end
    end
    @cog.resume(@args)
  end

end

class ReadDisallowed < StandardError; end
class WriteDisallowed < StandardError; end
