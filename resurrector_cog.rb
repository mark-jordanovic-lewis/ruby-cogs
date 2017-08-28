require 'cog'

class RessurrectorCog < Cog

  private

  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      Fiber.yield
      loop do
        case out = teeth.call(arg_hash)
        when :reinit then build_cog && break
        when :complete then break
        else Fiber.yield out
        end
      end
    end
    @cog.resume(@args)
  end
end
