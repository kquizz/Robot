require 'rspec'
require_relative '../lib/event_handler'

# Testing the Event Handler is pretty trivial, because it doesn't do much.
# Because of the dependency injection and the state machine pattern, the Event Handler is just a thin wrapper around the Ruby2d's event handling system
# We can test that it sets up the keyboard event handling, and that it handles key down and key up events.
RSpec.describe EventHandler do
  let(:mock_window) { instance_double("Window") }
  let(:mock_handle_event_key_down) { instance_double("Proc") }
  let(:mock_handle_event_key_up) { instance_double("Proc") }

  let(:opts) do
    {
      handle_event_key_down: mock_handle_event_key_down,
      handle_event_key_up: mock_handle_event_key_up,
      window: mock_window,
      mode: :keyboard
    }
  end

  describe '#initialize' do
    it 'sets up keyboard event handling' do
      expect(mock_window).to receive(:on).with(:key_down)
      expect(mock_window).to receive(:on).with(:key_up)

      EventHandler.new(opts)
    end
  end

  describe '#handle_key_down' do
    it 'handles key down events' do
      event = Struct.new(:key).new(:return)

      expect(mock_window).to receive(:on).with(:key_down).and_yield(event)
      expect(mock_window).to receive(:on).with(:key_up)

      expect(mock_handle_event_key_down).to receive(:call).with(:return)

      EventHandler.new(opts)
    end
  end

  describe '#handle_key_up' do
    it 'handles key up events' do
      event = Struct.new(:key).new(:return)

      expect(mock_window).to receive(:on).with(:key_down)
      expect(mock_window).to receive(:on).with(:key_up).and_yield(event)

      expect(mock_handle_event_key_up).to receive(:call).with(:return)

      EventHandler.new(opts)
    end
  end
end