require 'rspec'
require_relative '../lib/square_factory'

RSpec.describe SquareFactory do
  let(:graphic_square) { instance_double("GraphicSquare") }
  let(:square) { class_double("Square") }
  let(:square_instance) { instance_double("Square") }

  before do
    allow(graphic_square).to receive(:new).and_return(graphic_square)
    allow(square).to receive(:new).and_return(square_instance)
  end

  subject(:square_factory) { SquareFactory.new(graphic_square, square) }

  describe '#createSquare' do
    it 'creates a square' do
      expect(graphic_square).to receive(:new).with(x: 0, y: 0, size: 10, color: 'black')
      expect(square).to receive(:new).with(graphicSquare: graphic_square, ord: 1)

      square_factory.createSquare(x: 0, y: 0, size: 10, color: 'black', ord: 1)
    end
  end

  describe '#createSquares' do
    it 'creates multiple squares' do
      opts = { numSquares: 4, height: 200, width: 200, squareGap: 0.1, xOffset: 0, yOffset: 0 }
      expect(graphic_square).to receive(:new).exactly(4).times
      expect(square).to receive(:new).exactly(4).times

      squares = square_factory.createSquares(opts)

      expect(squares.size).to eq(4)
    end
  end
end