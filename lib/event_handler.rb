class EventHandler
  def initialize(opts)
    @window = opts[:window]
    @handle_event_key_down = opts[:handle_event_key_down]
    @handle_event_key_up = opts[:handle_event_key_up]
    @mode = opts[:mode] || :keyboard

    case @mode
    when :keyboard
      setup_keyboard_event_handling
    when :mouse
      # TODO:  Would be cool if the Robot just follows the mouse.
    when :scripted
      # TODO: Would be cool if the Robot followed a script.
    end
  end

  def setup_keyboard_event_handling
    @window.on :key_down do |event|
      @handle_event_key_down.call(event.key)
    end

    @window.on :key_up do |event|
      @handle_event_key_up.call(event.key)
    end
  end
end