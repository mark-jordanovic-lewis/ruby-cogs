require 'resurrector_cog'

RSpec.describe RessurrectorCog do
  describe "A ressurrector cog" do
    let(:cog) {
      RessurrectorCog.new(
        read_only: %i[count],
        accessors: %i[limit],
        args: {count: 0, limit:2, reset: 5}
      ) do |args|
        case
        when args[:count] > args[:limit] then :complete
        when args[:limit] > args[:reset] then :reinit
        else
          args[:count] += 1
          [ args[:count], args[:limit] ]
        end
      end
    }
    let(:cog_methods) {cog.methods}
    let(:methods) { %i[count limit limit=]}
    let(:not_methods) { %i[count=] }
    
    context 'when going through a life cycle', order: :default do

      it 'is initialized with the correct methods' do
        expect(methods.all? { |method| cog_methods.include? method }).to be true
        expect(not_methods.none? { |method| cog_methods.include? method}).to be true
      end

      it 'has variables initialized correctly' do
        expect(cog.count).to eq 0
        expect(cog.limit).to eq 2
      end

      it "goes to completion if b is not updated ('complete' test)" do
        expect(cog.turn).to eq [1,2]
        expect(cog.turn).to eq [2,2]
        expect(cog.turn).to eq [3,2]
        expect{cog.turn}.to raise_error(CogHasExited)
      end

      it "reinitializes if limit breaches reset ('reset' test)" do
        cog.limit = 6
        expect(cog.turn).to eq nil
        expect(cog.count).to eq 0
        expect(cog.limit).to eq 2
        expect(cog.turn).to eq [1,2]
      end
    end
  end
end
