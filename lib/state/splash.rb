require_relative 'state'

class State::Splash < State
    def initialize(opts)
      @firstLineText = opts[:firstLineText]
      @change_state = opts[:change_state]
      @hide_all = opts[:hide_all]
      @robot_set_super_speed = opts[:robot_set_super_speed]
      @key_history = []
    end

    def run 
      @firstLineText.text = "Press Enter to Start"
    end

    def handle_event_key_down(key)
      @key_history << key
      if key == 'return'
        # This line is intentianally obfuscated.
         @robot_set_super_speed.call if @key_history.last(11).join.chars.each_with_index.reduce(0){ |a, (b, c)| a + (b.ord * c) } == 76254
         @change_state.call(:Running) 
      end
    end

    def handle_event_key_up(key)
    end

    def change_state
      @hide_all.call
    end
  end