require_relative 'cog'
require 'securerandom'
# this cog will both respawn and spawn a new cog

class ActorCog < Cog

  DEFAULT_NAME = { name: SecureRandom.hex(3) }
  DEFAULT_MAX_MSGS = { max_messages: 20 }

  def initialize(read_only: %i[], accessors: %i[], args: {}, &teeth)
    @read_only = read_only
    @accessors = accessors
    @writers = accessors - read_only
    @readers = (accessors+read_only).uniq
    @respawn_args = args.dup
    args.merge! DEFAULT_NAME unless args[:name]
    args.merge! DEFAULT_MAX_MSGS unless args[:max_messages]
    @args = args.merge(mailbox: [])
    build_readers
    build_writers
    build_cog(&teeth)
  end

  def new_message(message)
    if @args[:mailbox].size < @args[:max_messages]
      @args[:mailbox] << message
      [:stored, message]
    else
      [:rejected, message]
    end
  end

  def next_message
    @args[:mailbox].shift
  end

  def name
    @args[:name]
  end

  private

  def build_cog(&teeth)
    @cog = Fiber.new do |arg_hash|
      respawn = false
      Fiber.yield arg_hash[:name]
      loop do
        case out = teeth.call(arg_hash)
        when :complete then destroy_fiber && break
        when :replicate
          @respawn_args[:replicants] = arg_hash[:replicants] += 1
          Fiber.yield new_cog("_#{SecureRandom.hex(3)}", &teeth)
        when :reinit
          build_cog(&teeth)
          break
        else
          Fiber.yield out
        end
      end
    end
    @cog.resume(@args)
  end

  def new_cog(name, read_only: @read_only, accessors: @accessors, args: @respawn_args, &teeth)
    new_name = args[:name]+name
    [ new_name,
      ActorCog.new(read_only: read_only,
                   accessors: accessors,
                   args: args.merge(name: new_name),
                   &teeth)
    ]
  end
end

#      {
#        case next_message
#        when :possible_message_1
#          # do the thing and return something
#          # messages should be sent to the stage cog (container) like:
#          # return [:msg, { to: cog_name, msg: :msg_symbol}]
#        when :possible_message_2
#          # do the thing and return something
#          # possibly return a new cog from here like:
#          # return [:new_cog, {cog: Cog.new(...), name: new_cog_name}]
#        else
#          # return a default
#        end
#      }
