require 'rspec'
require_relative '../lib/square'

RSpec.describe Square do
  let(:graphic_square) { instance_double("GraphicSquare") }

  let(:opts) do
    {
      graphicSquare: graphic_square,
      ord: 1
    }
  end

  before do
    allow(graphic_square).to receive(:x).and_return(0)
    allow(graphic_square).to receive(:y).and_return(0)
    allow(graphic_square).to receive(:size).and_return(10)
    allow(graphic_square).to receive(:color=)
  end

  subject(:square) { Square.new(opts) }

  describe '#initialize' do
    it 'initializes the square' do
      expect(square.ord).to eq(1)
      expect(square.count).to eq(0)
      expect(square.used_ticks).to eq(0)
    end
  end

  describe '#contains?' do
    it 'checks if the square contains a point' do
      expect(square.contains?(5, 5, 2, 2)).to be true
      expect(square.contains?(15, 15, 2, 2)).to be false
    end
  end

  describe '#color=' do
    it 'sets the color of the square' do
      expect(graphic_square).to receive(:color=).with('red')

      square.color = 'red'
    end
  end

  describe '#enter' do
    it 'increments the count and changes the color' do
      expect(graphic_square).to receive(:color=).with('random')

      square.enter

      expect(square.count).to eq(1)
    end
  end

  describe '#occupy' do
    it 'increments the used_ticks' do
      square.occupy

      expect(square.used_ticks).to eq(1)
    end
  end
end