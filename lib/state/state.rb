class State
  attr_reader :current_state

  def initialize(states)
    @states = states 
    @current_state = nil
    change_state(:Splash)
  end

  def run 
    @states[@current_state].run
  end

  def handle_event_key_down(event)
    @states[@current_state].handle_event_key_down(event)
  end

  def handle_event_key_up(event)
    @states[@current_state].handle_event_key_up(event)
  end

  def change_state(new_state)
    @current_state = new_state
    @states[new_state].change_state
  end
end