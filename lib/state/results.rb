require_relative 'state'

class State::Results < State
  def initialize(opts)
    @firstLineText            = opts[:firstLineText]
    @change_state             = opts[:change_state]
    @close_window             = opts[:close_window]
    @squares_count_map        = opts[:squares_count_map]
    @squares_ticks_map        = opts[:squares_ticks_map]
    @squares_color_map        = opts[:squares_color_map]
    @frame_started            = opts[:frame_started]
    @frame_finished           = opts[:frame_finished]
    @robot_movement_history   = opts[:robot_movement_history]
    @robot_distance_travelled = opts[:robot_distance_travelled]
    @robot_final_location     = opts[:robot_final_location]
    @robot_speed              = opts[:robot_speed]
    @fps                      = opts[:fps]
    @window_width             = opts[:window_width]
    @window_height            = opts[:window_height]
    @text                     = opts[:text]
    @squareFactory            = opts[:squareFactory]
    @line                     = opts[:line]

    @results = nil # Storing results in an instance variable, so we don't have to calculate it more than once.
  end

  def run 
    @firstLineText.text = "Here are the results!    Press Enter or 'q' to Exit."
    @results ||= calculate_results(squares_count_map:            @squares_count_map.call,
                                   squares_ticks_map:            @squares_ticks_map.call,
                                   squares_color_map:            @squares_color_map.call,
                                   frame_started:                @frame_started.call,
                                   frame_finished:               @frame_finished.call,
                                   robot_movement_history:       @robot_movement_history.call,
                                   robot_distance_travelled:     @robot_distance_travelled.call,
                                   robot_final_location:         @robot_final_location.call,
                                   robot_speed:                  @robot_speed.call,
                                   fps:                          @fps,
                                   window_width:                 @window_width,
                                   window_height:                @window_height)
    display_results(@results, 0, 0)
  end

  def handle_event_key_down(key)
    @close_window.call if key == 'return' || key == 'q'
    
    # Would be cool if there was a way to restart the game. Maybe a 'r' key?
    # it could save your time and compare it to your previous time.
    # maybe a text file that saves your best time.
  end
  
  def handle_event_key_up(key)
  end

  def change_state
  end

  private

  def calculate_results(opts)
    results = {}
    frames_to_finish = (opts[:frame_finished].to_i - opts[:frame_started].to_i)
    results[:squares_entered] = opts[:squares_count_map].reduce(0){|sum, s| sum + s}
    results[:time_to_finish] = ( frames_to_finish / opts[:fps].to_f).round(2)
    movement_count = opts[:robot_movement_history].count.to_f
    results[:left_percent] = (opts[:robot_movement_history].count('left') / movement_count * 100).to_i
    results[:right_percent] = (opts[:robot_movement_history].count('right') / movement_count * 100).to_i
    results[:up_percent] = (opts[:robot_movement_history].count('up') / movement_count * 100).to_i
    results[:down_percent] = (opts[:robot_movement_history].count('down') / movement_count * 100).to_i
    results[:still_percent] = (opts[:robot_movement_history].count('still') / movement_count * 100).to_i

    results[:distance_travelled] = opts[:robot_distance_travelled]
    results[:robot_speed] = opts[:robot_speed]
    results[:final_location] = opts[:robot_final_location]
    results[:squares_ticks_map] = opts[:squares_ticks_map]
    results[:squares_count_map] = opts[:squares_count_map]
    results[:squares_color_map] = opts[:squares_color_map]
    results[:window_width] = opts[:window_width]
    results[:window_height] = opts[:window_height]
    results[:robot_movement_history] = opts[:robot_movement_history]
    results
  end

  def display_results(results, xOffset, yOffset)
    locations = {
      x: 2.times.map { |i| 0  + i * 300 + xOffset },
      y: 6.times.map { |i| 25 + i * 20  + yOffset }
    }

    # 1st Column
    @text.new("Distance Travelled: #{results[:distance_travelled].to_s} pixels", x: locations[:x][0], y: locations[:y][0], z: 10)
    @text.new("Final Location: #{results[:final_location]}", x: locations[:x][0], y: locations[:y][1], z: 10)
    @text.new("Time to Finish: #{results[:time_to_finish].to_s} seconds", x: locations[:x][0], y: locations[:y][2], z: 10)
    @text.new('Squares Entered: ' + results[:squares_entered].to_s, x: locations[:x][0], y: locations[:y][3], z: 10)
    
    # 2nd Column 
    middleAlignXOffset = 50
    @text.new('Movement Percentages:', x: locations[:x][1], y: locations[:y][0], z: 10)
    @text.new('Left: ' + results[:left_percent].to_s + '%', x: locations[:x][1] + middleAlignXOffset, y: locations[:y][1], z: 10)
    @text.new('Right: ' + results[:right_percent].to_s + '%', x: locations[:x][1] + middleAlignXOffset, y: locations[:y][2], z: 10)
    @text.new('Up: ' + results[:up_percent].to_s + '%', x: locations[:x][1] + middleAlignXOffset, y: locations[:y][3], z: 10)
    @text.new('Down: ' + results[:down_percent].to_s + '%', x: locations[:x][1] + middleAlignXOffset, y: locations[:y][4], z: 10)
    @text.new('Still: ' + results[:still_percent].to_s + '%', x: locations[:x][1] + middleAlignXOffset, y: locations[:y][5], z: 10)

    # 3rd Column
    # Display Favorite Location
    # Display time VS "optimum" Time
    # Display something if they got the code right during the splash screen.

    # Display Maps
    display_squares_percent_time_spent(results, 0 , 195)
    display_squares_number_times_entered(results, 250, 195)
    display_squares_final_color(results, 500, 195)
    display_robot_path(results, 0, 500)

    # Display Robot Favorite locations. robot.location_history.histogram.
    # Make circles that are as large as the number of times the robot visited that location.
    # difficulty will be translating the x, y coordinates to the mini map.

    # Come up with 1 more map to complete the bottom half of the screen.
  end

  def display_squares_percent_time_spent(results, xOffset, yOffset)
    squares = results[:squares_ticks_map]
    
    @text.new('Time Spent Heatmap:', x: 20 + xOffset, y: yOffset, z: 10)
    timePercentSquares = @squareFactory.createSquares(numSquares: squares.count,
                                                        width: results[:window_width] * 0.3,
                                                        height: results[:window_height] * 0.3,
                                                        squareGap: 0,
                                                        xOffset: 5 + xOffset,
                                                        yOffset: 25 + yOffset)
    min_ticks = squares.min_by { |s| s }
    max_ticks = squares.max_by { |s| s }
    range_ticks = max_ticks - min_ticks

    squares.each_with_index do |s, i|
      normalized_ticks = (s - min_ticks).to_f / range_ticks
      timePercentSquares[i].graphicSquare.color = color_gradient(normalized_ticks)
    end
  end

  def display_squares_number_times_entered(results, xOffset, yOffset)
    squares = results[:squares_count_map]

    @text.new('Times Entered Heatmap:', x: 20 + xOffset, y: yOffset, z: 10)
    countPercentSquares = @squareFactory.createSquares(numSquares: squares.count, 
                                                        height: results[:window_height] * 0.3, 
                                                        width: results[:window_width] * 0.3, 
                                                        squareGap: 0,
                                                        xOffset: 5 + xOffset,
                                                        yOffset: 25 + yOffset)
    min_count = squares.min_by { |s| s }
    max_count = squares.max_by { |s| s }
    range_count = max_count - min_count
    range_count =  1 if range_count == 0

    squares.each_with_index do |s, i|
      normalized_count = (s - min_count).to_f / range_count
      countPercentSquares[i].graphicSquare.color = color_gradient(normalized_count)
    end
  end

  def display_squares_final_color(results, xOffset, yOffset)
    squares = results[:squares_color_map]

    @text.new('Final Colors:', x: 30 + xOffset, y: yOffset, z: 10)
    finalColorSquares = @squareFactory.createSquares(numSquares: squares.count, 
                                                      height: results[:window_height] * 0.3, 
                                                      width: results[:window_width] * 0.3, 
                                                      squareGap: 0,
                                                      xOffset: 5 + xOffset,
                                                      yOffset: 25 + yOffset)
    squares.each_with_index do |s, i|
      finalColorSquares[i].graphicSquare.color = s
    end
  end

  def display_robot_path(results, xOffset, yOffset)
    @text.new('Robot Path:', x: 30 + xOffset, y: yOffset, z: 10)
    displayRobotPathSquares = @squareFactory.createSquares(numSquares: results[:squares_count_map].count, 
                                                    height: results[:window_height] * 0.3, 
                                                    width: results[:window_width] * 0.3, 
                                                    squareGap: 0,
                                                    xOffset: 5 + xOffset,
                                                    yOffset: 25 + yOffset)

    xRobot = 40 + xOffset
    yRobot = 70 + yOffset
    step = (results[:robot_speed] == 5 ? 1.5 : 3)

    movements = results[:robot_movement_history].select{|m| m != 'still'}

    movements_length = movements.length.to_f
    movements.each_with_index do |p, i|
      xRobotLast = xRobot
      yRobotLast = yRobot
      colorRatio = i / movements_length

      case p
      when 'right'
        xRobot += step
      when 'left'
        xRobot -= step
      when 'down'
        yRobot += step
      when 'up'
        yRobot -= step
      end
      
      @line.new(x1: xRobotLast, y1: yRobotLast, x2: xRobot, y2: yRobot, width: 5, color: color_gradient(colorRatio), z:10)
    end
  end

  def color_gradient(value)
    raise ArgumentError, "Value must be between 0 and 1" unless (0..1).include?(value)

    red = (255 * value).to_i
    green = (255 * (1 - value)).to_i

    sprintf("#%02X%02X00", red, green)
  end
end