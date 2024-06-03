require_relative 'state'

class State::Won < State
  def initialize(opts)
    @firstLineText = opts[:firstLineText]
    @change_state = opts[:change_state]
    @close_window = opts[:close_window]
    @hide_all = opts[:hide_all]
    @stop_timer = opts[:stop_timer]
  end

  def run 
    @firstLineText.text = "You Won! Press Enter to Continue"
  end

  def handle_event_key_down(key)
    @change_state.call(:Results) if key == 'return'
    @close_window.call if key == 'q'
  end

  def handle_event_key_up(key)
  end

  def change_state
    @stop_timer.call
    @hide_all.call
  end
end