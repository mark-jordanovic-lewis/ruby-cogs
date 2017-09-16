require 'actor_cog'

RSpec.describe ActorCog do
  let(:cog) {
    ActorCog.new(
      read_only: %i[replicants],
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

    it 'accepts incoming messages' do
      expect(cog.new_message 'one').to eq [:stored, 'one']
      expect(cog.new_message 'two').to eq [:stored, 'two']
      expect(cog.new_message 'three').to eq [:stored, 'three']
    end

    it 'rejects a message that overflows its mailbox' do
      3.times {|i| cog.new_message "#{i}" }
      expect(cog.new_message 'four').to eq [:rejected, 'four']
    end

    it 'generates another actor cog when mail box limit reached' do
      3.times {|i| cog.new_message "#{i}" }
      _, new_cog = cog.turn
      expect(new_cog.class).to eq ActorCog
      expect(cog.replicants).to eq 1
      expect(new_cog.replicants).to eq 1
      expect(new_cog.new_message 'four').to eq [:stored, 'four']
    end

  end
end
