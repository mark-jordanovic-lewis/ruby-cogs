require 'cog'

class RessurrectorCog < Cog
  def initialize(read_only: %i[], accessors: %i[], args: {}, &teeth)
    super
    @reinit_args = @args.dup
  end
  private

  # I really hope all these unassigned fibers are gc'd
  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      Fiber.yield
      loop do
        case out = teeth.call(arg_hash)
        when :reinit
          @args = @reinit_args.dup
          build_cog(&teeth)
          break
        when :complete
          destroy_fiber
          break
        else Fiber.yield out
        end
      end
    end
    @cog.resume(@args)
  end
end
