require 'rspec'
require_relative '../../lib/state/running'

RSpec.describe State::Running do
  let(:first_line_text) { instance_double("Text") }
  let(:robot_set_direction) { instance_double("Proc") }
  let(:robot_move) { instance_double("Proc") }
  let(:robot_display) { instance_double("Proc") }
  let(:robot_record_location) { instance_double("Proc") }
  let(:check_collisions) { instance_double("Proc") }
  let(:check_win_condition) { instance_double("Proc") }
  let(:show_all) { instance_double("Proc") }
  let(:start_timer) { instance_double("Proc") }

  let(:opts) do
    {
      firstLineText: first_line_text,
      robot_set_direction: robot_set_direction,
      robot_move: robot_move,
      robot_display: robot_display,
      robot_record_location: robot_record_location,
      check_collisions: check_collisions,
      check_win_condition: check_win_condition,
      show_all: show_all,
      start_timer: start_timer
    }
  end

  subject(:running_state) { State::Running.new(opts) }

  describe '#run' do
    it 'runs the game' do
      expect(first_line_text).to receive(:text=).with('')
      expect(robot_move).to receive(:call)
      expect(check_collisions).to receive(:call)
      expect(robot_display).to receive(:call)
      expect(robot_record_location).to receive(:call)
      expect(check_win_condition).to receive(:call)

      running_state.run
    end
  end

  describe '#handle_event_key_down' do
    it 'handles key down events' do
      expect(robot_set_direction).to receive(:call).with('left')

      running_state.handle_event_key_down("left")
    end
  end

  describe '#handle_event_key_up' do
    it 'handles key up events' do
      expect(robot_set_direction).to receive(:call).with('still')

      running_state.handle_event_key_up("left")
    end
  end

  describe '#change_state' do
    it 'changes the state' do
      expect(show_all).to receive(:call)
      expect(start_timer).to receive(:call)

      running_state.change_state
    end
  end
end