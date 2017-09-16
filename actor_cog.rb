require_relative 'cog'

# this cog will both respawn and spawn a new cog

class ActorCog < Cog
  def initialize(read_only: %i[], accessors: %i[], args: {}, name: :stage, &teeth)
    accessors << :mailbox
    super
    @name = name
    @args.merge(mailbox: [])
    @respawn_args = args.dup
    @read_only = read_only
    @teeth = teeth.dup
    @accessors = accessors
  end

  private

  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      Fiber.yield
      loop do
        case out = teeth.call(arg_hash)
        when :reinit then build_cog && break
        when :complete then break
        when :respawn
          Fiber.yeild [@name,
                       ActorCog.new(read_only: @read_only,
                                    accessors: @accessors,
                                    args: @respawn_args,
                                    name: @name,
                                    &teeth
                                   )
                      ]
        else Fiber.yield out
        end
      end
    end
    @cog.resume(@args)
  end

  def next_message
    message = @args[:mailbox].pop
    @args[:mailbox].drop
    message
  end
end

{
  case next_message
  when :possible_message_1
    # do the thing and return something
    # messages should be sent to the stage cog (container) like:
    # return [:msg, { to: cog_name, msg: :msg_symbol}]
  when :possible_message_2
    # do the thing and return something
    # possibly return a new cog from here like:
    # return [:new_cog, {cog: Cog.new(...), name: new_cog_name}]
  else
    # return a default
  end
}
