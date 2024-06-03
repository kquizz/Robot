class GameBoard 
  # attr_reader :robot

  def initialize(opts)
    @numSquares = opts[:numSquares]
    @window = opts[:window]
    @window.set(width: opts[:width], height: opts[:height], title: opts[:title])
    @text = opts[:text]
    @line = opts[:line]
    @speed = 5 # Default speed for the robot
    

    # The Square Factory is responsible for creating Squares. 
    # It's main function is the createSquares method which creates an array of Squares.
    @squareFactory = opts[:squareFactory]
    @squares = @squareFactory.createSquares(numSquares: opts[:numSquares], 
                                                  height: opts[:height], 
                                                  width: opts[:width], 
                                                  squareGap: opts[:gapPercent] / 100.0)

    @robot = opts[:robot].new(x: 100, y: 100, height: 64, width: 64, graphicsSprite: opts[:sprite], speed: @speed)

    firstLineText = @text.new('')

    # These are used to track how long the Robot takes to complete the challenge.
    @frame_started = nil
    @frame_finished = nil

    # Create the different states
    @splash = opts[:splash].new(firstLineText:          firstLineText,
                                change_state:          ->(e){change_state(e)},
                                hide_all:              ->{hide_all},
                                robot_set_super_speed: ->{@robot.speed = 10})

    @running = opts[:running].new(firstLineText:          firstLineText,
                                  robot_set_direction:   ->(e){@robot.set_direction(e)},
                                  robot_move:            ->{@robot.move},
                                  robot_display:         ->{@robot.display},
                                  robot_record_location: ->{@robot.record_location},
                                  start_timer:           ->{@frame_started = @window.frames},
                                  check_collisions:      ->{check_collisions},
                                  check_win_condition:   ->{check_win_condition},
                                  show_all:              ->{show_all})

    @won = opts[:won].new(firstLineText: firstLineText, 
                          change_state: ->(e){change_state(e)},
                          hide_all:     ->{hide_all},
                          stop_timer:   ->{@frame_finished = @window.frames},
                          close_window: ->{@window.close})
    
    @results = opts[:results].new(firstLineText:             firstLineText,
                                  change_state:             ->(e){change_state(e)},
                                  close_window:             ->{@window.close},
                                  squares_count_map:        ->{@squares.map{|s| s.count}},
                                  squares_ticks_map:        ->{@squares.map{|s| s.used_ticks}},
                                  squares_color_map:        ->{@squares.map{|s| s.graphicSquare.color}},
                                  frame_started:            ->{@frame_started},
                                  frame_finished:           ->{@frame_finished},
                                  robot_movement_history:   ->{@robot.movement_history},
                                  robot_distance_travelled: ->{@robot.distance_travelled},
                                  robot_final_location:     ->{[@robot.sprite.x, @robot.sprite.y]},
                                  robot_speed:              ->{@robot.speed},
                                  fps:                       @window.fps,
                                  window_width:              @window.width,
                                  window_height:             @window.height,
                                  text:                      @text,
                                  line:                      @line,
                                  squareFactory:             @squareFactory)

    # Create the state object that holds the above states and automatically decides which state's actions should be run
    # This also sets the current state to Splash
    @state = opts[:state].new({Splash: @splash, Running: @running, Won: @won, Results: @results})

    opts[:eventHandler].new(window:                 @window,
                            handle_event_key_down: ->(key){@state.handle_event_key_down(key)},
                            handle_event_key_up:   ->(key){@state.handle_event_key_up(key)},
                            state:                  @state)
  end

  def run
    @window.update do
      @state.run
    end
    @window.show
  end

  def check_win_condition
    # Change the state to Won if all the squares have been visited
    change_state(:Won) if @squares.select{|s| s.count == 0}.empty?
  end

  def change_state(new_state)
    @state.change_state(new_state)
  end

  def check_collisions
    collidingSquares = @squares.select{|s| s.contains?(@robot.sprite.x, @robot.sprite.y, @robot.width, @robot.height)}
    if collidingSquares.empty?
      @robot.currentSquare = nil
    else
      collidingSquares.each do |s|
        s.occupy
        if @robot.currentSquare != s.ord
          s.enter
          @robot.currentSquare = s.ord
        end
      end
    end
  end

  def hide_all
    @squares.each{|s| s.graphicSquare.remove}
    @robot.sprite.remove
  end

  def show_all
    @squares.each{|s| s.graphicSquare.add}
    @robot.sprite.add
  end
end