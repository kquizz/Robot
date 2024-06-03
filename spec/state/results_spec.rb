require 'rspec'
require_relative '../../lib/state/results'

RSpec.describe State::Results do
  before do
    @results = State::Results.new({})
  end
 
  describe '#calculate_results' do
    it 'calculates the results correctly' do
      opts = {
        squares_count_map: [1, 2, 3],
        squares_ticks_map: [10, 20, 30],
        squares_color_map: ['red', 'green', 'blue'],
        frame_started: 0,
        frame_finished: 100,
        robot_movement_history: ['up', 'down', 'left', 'right'],
        robot_distance_travelled: 100,
        robot_final_location: [50, 50],
        fps: 30,
        window_width: 800,
        window_height: 600
      }

      expected_results = {
        squares_entered: 6,
        time_to_finish: 3.33,
        left_percent: 25,
        right_percent: 25,
        up_percent: 25,
        down_percent: 25,
        still_percent: 0,
        distance_travelled: 100,
        final_location: [50, 50],
        squares_ticks_map: [10, 20, 30],
        squares_count_map: [1, 2, 3],
        squares_color_map: ['red', 'green', 'blue'],
        window_width: 800,
        window_height: 600,
        robot_movement_history: ['up', 'down', 'left', 'right']
      }

      expect(@results.send(:calculate_results, opts)).to eq(expected_results)
    end
  end
end