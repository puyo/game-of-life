require 'rspec'
require File.expand_path('life', File.dirname(__FILE__))

describe Life::Universe do
  let(:universe) { Life::Universe.new(seed) }

  describe '#live?' do
    subject { universe.live?(at) }

    context 'when the universe is seeded at (0,0)' do
      let(:seed) { [[0, 0]] }

      context 'at (0,0)' do
	let(:at) { [0,0] }
	it { should be_true }
      end

      context 'at (0,1)' do
	let(:at) { [0,1] }
	it { should be_false }
      end
    end
  end

  describe '#live_positions' do
    subject { universe.live_positions }

    context 'after one universe.tick!' do
      before { universe.tick! }

      context 'when the universe is seeded empty' do
	let(:seed) { [] }
	it { should be_empty }
      end

      context 'when the universe is seeded at (0,0)' do
	let(:seed) { [[0, 0]] }
	it { should be_empty }
      end

      context 'when the universe is seeded at (0,1), (1,0) and (1,1)' do
	let(:seed) { [[0, 1], [1, 0], [1, 1]] }
	it { should have(4).cells }
	it { should include([0, 0]) } # baby!
	it { should include([0, 1]) }
	it { should include([1, 0]) }
	it { should include([1, 1]) }
      end
    end
  end
end
