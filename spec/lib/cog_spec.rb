require 'cog'

RSpec.describe Cog do
  context 'A cog with no teeth' do
    context 'and no variables' do
      let(:cog) { Cog.new(){} }

      it 'should generate a new Cog' do
          expect(cog.turn).to be nil
      end
    end

    context 'with only internal state variables initialized' do
      let(:cog){ Cog.new(args:{a: 5}){} }

      it 'should not allow variable to be read' do
        expect{cog.a}.to raise_error(NoMethodError)
      end

      it 'should not allow variable to be written' do
        expect{cog.a = 4}.to raise_error(NoMethodError)
      end
    end

    context 'with only read_only variables (initialized)' do
      let(:cog){ Cog.new(read_only: %i[a], args:{a: 5}){} }

      it 'should allow variable to be read' do
        expect(cog.a).to eq 5
      end

      it 'should not allow variable to be written' do
        expect{cog.a = 4}.to raise_error(NoMethodError)
      end
    end

    context 'with accessible variables' do
      let(:cog){ Cog.new(accessors: %i[a], args:{a: 5}){} }

      it 'should allow variable to be read' do
        expect(cog.a).to eq 5
      end

      it 'should allow variable to be written' do
        cog.a = 4
        expect(cog.a).to eq 4
      end
    end
  end

  context 'A cog that exits' do
    context 'and that\'s all it does' do
      let(:cog){ Cog.new(){|args| :complete } }

      it 'should stop and raise CogHasExited' do
        expect{cog.turn}.to raise_error(CogHasExited)
      end

      it 'should keep raising CogHasExited errors' do
        expect{cog.turn}.to raise_error(CogHasExited)
        expect{cog.turn}.to raise_error(CogHasExited)
        expect{cog.turn}.to raise_error(CogHasExited)
      end
    end

    context 'that turns ten times and then exits' do
      let(:cog){ Cog.new(args: { a:10 } ) do |args|
                   args[:a].zero? ? :complete : args[:a] -= 1
                 end
               }

      it 'should output (9..0) then exit' do
        10.times { |i| expect(cog.turn).to eq (9-i) }
        expect{cog.turn}.to raise_error(CogHasExited)
      end
    end
  end

  context 'A cog with accessors and read_only variables', order: :default do
    let(:cog){ Cog.new(read_only: %i[a c], accessors: %i[a b], args:{a: 5}){} }
    let(:methods) { %i[a b b= c] }
    let(:not_methods) { %i[a= c=] }
    let(:cog_methods) { cog.methods }

    it "'a' is initialized" do # duplicate but different scenario
      expect(cog.a).to eq 5
    end

    it "'c' and 'b' are not initialized" do
      expect(cog.c).to be nil
      expect(cog.b).to be nil
    end

    it "'b' can be written" do
      cog.b = 4
      expect(cog.b).to eq 4
    end

    it 'builds all the readers and writers' do
      expect(methods.all? { |method| cog_methods.include? method }).to be true
    end
    it 'should not build writers to read_only variables' do
      expect(not_methods.none? { |method| cog_methods.include? method}).to be true
    end
  end
end
