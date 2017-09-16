require 'actor_cog'

RSpec.describe ActorCog do
  let(:cog) {
    ActorCog.new(
      args: {
        max_messages: 3,
        max_replicants: 2,
        replicants: 0
      }
    ) do |args|
      args[:mailbox].size >= 3 ? :replicate : args[:mailbox]
    end
  }

  context "An actor cog that yeilds it's mailbox until it is full" do

    it 'should accept incoming messages' do
      expect(cog.new_message 'one').to eq [:stored, 'one']
      expect(cog.new_message 'two').to eq [:stored, 'two']
      expect(cog.turn).to eq %w[one two]
    end

    it 'should replicate itself when max_messages reached' do
      expect(cog.new_message 'one').to eq [:stored, 'one']
      expect(cog.new_message 'two').to eq [:stored, 'two']
      expect(cog.new_message 'three').to eq [:stored, 'three']
      expect(cog.new_message 'four').to eq [:rejected, 'four']
      expect(cog.turn.class).to eq 'ActorCog'
    end

  end
end
