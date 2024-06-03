class SquareFactory
  # The graphicSquare is used to display the square
  # the square is the wrapper for graphicSquare that provides additional functionality.
  def initialize(graphicSquare, square)
    @graphicSquare = graphicSquare
    @square = square
  end

  def createSquare(options = {})
    x      = options[:x]
    y      = options[:y]
    size   = options[:size]
    color  = options[:color]
    ord    = options[:ord]
    graphicSquare = @graphicSquare.new(x: x, y: y, size: size, color: color)
    @square.new(graphicSquare: graphicSquare, ord: ord)
  end

  # This is loosely copied from a P4 sketch I wrote that lets you play Simon with an NxN grid
  # It's a little much for this, but it let's you change numSquares and have all the math check out.
  # https://editor.p4js.org/kquizz/sketches/A24k4YfKa
  def createSquares(opts)
    columns    = Math.sqrt(opts[:numSquares]).ceil
    rows       = (opts[:numSquares] / columns).ceil
    cellHeight = opts[:height] / rows
    cellWidth  = opts[:width] / columns
    gap        = cellWidth * opts[:squareGap]
    halfGap    = 0.5 * gap # Half gap is used to create margins around outside perimeter
    xOffset    = opts[:xOffset] || 0;
    yOffset    = opts[:yOffset] || 0;

    squares = []
    
    for i in 0..opts[:numSquares] - 1 do
      x = (i % columns) * cellWidth
      y = (i / columns).floor * cellHeight

      squares << createSquare( x:      x + halfGap + xOffset,
                                y:     y + halfGap + yOffset,
                                size:  cellWidth - gap,
                                color: 'black',
                                ord:   i)
    end
    squares
  end
end