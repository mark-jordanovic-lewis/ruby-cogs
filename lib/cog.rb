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
    @readers = (accessors+read_only).uniq
    @args = args
    build_readers
    build_writers
    build_cog(&teeth)
  end

  def turn
    @cog&.alive? ? @cog.resume : raise(CogHasExited)
  end

  private

  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      Fiber.yield
      loop do
        out = teeth.call(arg_hash)
        out == :complete ? destroy_fiber && break : Fiber.yield(out)
      end
    end
    @cog.resume(@args)
  end

  def destroy_fiber
    @cog = nil
    raise CogHasExited
  end

  def build_writers
    @writers.each do |w|
      define_singleton_method("#{w}=".to_sym) {|var| @args[w] = var }
    end
  end

  def build_readers
    (@readers).each do |a|
      define_singleton_method(a) { @args[a] }
    end
  end
end

class CogHasExited < StandardError; end
