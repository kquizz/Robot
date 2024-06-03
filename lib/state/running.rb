require_relative 'state'

class State::Running < State
  def initialize(opts)
    @firstLineText = opts[:firstLineText]
    @robot_set_direction = opts[:robot_set_direction]
    @robot_move = opts[:robot_move]
    @robot_display = opts[:robot_display]
    @robot_record_location = opts[:robot_record_location]
    @check_collisions = opts[:check_collisions]
    @check_win_condition = opts[:check_win_condition]
    @show_all = opts[:show_all]
    @start_timer = opts[:start_timer]

  end

  def run 
    @firstLineText.text = ''

    @robot_move.call
    @check_collisions.call
    @robot_display.call
    @robot_record_location.call
    @check_win_condition.call
  end

  def handle_event_key_down(key)
    @robot_set_direction.call(key)
  end

  def handle_event_key_up(key)
    @robot_set_direction.call('still')
  end

  def change_state
    @show_all.call
    @start_timer.call
  end
end