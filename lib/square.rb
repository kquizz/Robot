class Square
  attr_reader :ord
  attr_accessor :count, :used_ticks, :graphicSquare

  def initialize(opts = {})
    @ord           = opts[:ord]
    @graphicSquare = opts[:graphicSquare]
    @count         = 0 # This counts how many times the robot entered the square
    @used_ticks    = 0 # This counts how long the robot is in the square
  end

  def contains?(x, y, width, height)
    x + width/2 >= @graphicSquare.x && x + width/2 <= @graphicSquare.x + @graphicSquare.size &&
    y + height/2 >= @graphicSquare.y && y + height/2 <= @graphicSquare.y + @graphicSquare.size
  end

  def color=(color)
    @graphicSquare.color = color
  end

  def enter
    @count += 1
    self.color = 'random'
  end

  def occupy
    @used_ticks += 1
  end
end