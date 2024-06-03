class Robot
  attr_accessor :movement_mode, :currentSquare, :speed
  attr_reader :sprite, :height, :width, :distance_travelled, :squares_entered, :location_history, :movement_history
  
  def initialize(opts)
    @sprite = opts[:graphicsSprite].new( path = 'lib/assets/spritesheet.png',
                                          clip_width: 64,
                                          time: 100,
                                          loop: true,
                                          width: opts[:width],
                                          height: opts[:height],
                                          animations: {
                                            left_right: 1..6,
                                            up_down: 7..11
                                          }
                                        )
    @sprite.x = opts[:x]
    @sprite.y = opts[:y]
    @height = opts[:height]
    @width = opts[:width]
    @movement_mode = 'still'
    @looking = 'right'
    @currentSquare = nil
    @location_history = []
    @movement_history = []
    @distance_travelled = 0
    @squares_entered = 0
    @speed = opts[:speed] || 5
  end

  def record_location
    @location_history << [@sprite.x, @sprite.y]
  end

  def set_direction(direction)
    @movement_mode = direction if %w(up down left right still).include?(direction)
    @looking = direction if %w(left right).include?(direction)
  end

  def move
    @movement_history << @movement_mode if %w(up down left right still).include?(@movement_mode)
    return unless %w(up down left right).include?(@movement_mode)

    @distance_travelled += @speed # This is used in the Results screen

    case @movement_mode
    when 'left'
      @sprite.x -= @speed
    when 'right'
      @sprite.x += @speed
    when 'up'
      @sprite.y -= @speed
    when 'down'
      @sprite.y += @speed
    end
  end

  def display
    if %w[still up down].include?(@movement_mode)
      @sprite.play animation: :up_down, loop: :true
    else
      if @looking == 'left'
        @sprite.play animation: :left_right, loop: :true
      else
        @sprite.play animation: :left_right, loop: :true, flip: :horizontal
      end
    end
  end
end