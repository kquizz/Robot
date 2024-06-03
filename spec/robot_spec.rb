require 'rspec'
require_relative '../lib/robot'

RSpec.describe Robot do
  let(:graphics_sprite) { instance_double("GraphicsSprite") }
  let(:sprite) { instance_double("Sprite") }

  let(:opts) do
    {
      graphicsSprite: graphics_sprite,
      width: 64,
      height: 64,
      x: 0,
      y: 0,
      speed: 5
    }
  end

  before do
    allow(graphics_sprite).to receive(:new).and_return(sprite)
    allow(sprite).to receive(:x=)
    allow(sprite).to receive(:y=)
    allow(sprite).to receive(:play)
  end

  subject(:robot) { Robot.new(opts) }

  describe '#initialize' do
    it 'initializes the robot' do
      expect(graphics_sprite).to receive(:new)
      expect(sprite).to receive(:x=).with(0)
      expect(sprite).to receive(:y=).with(0)

      robot
    end
  end

  describe '#record_location' do
    it 'records the location' do
      allow(sprite).to receive(:x).and_return(0)
      allow(sprite).to receive(:y).and_return(0)

      robot.record_location

      expect(robot.location_history).to include([0, 0])
    end
  end

  describe '#set_direction' do
    it 'sets the direction up' do
      robot.set_direction('up')
      expect(robot.movement_mode).to eq('up')
    end

    it 'sets the direction down' do
      robot.set_direction('down')
      expect(robot.movement_mode).to eq('down')
    end

    it 'sets the direction left' do
      robot.set_direction('left')
      expect(robot.movement_mode).to eq('left')
    end

    it 'sets the direction right' do
      robot.set_direction('right')
      expect(robot.movement_mode).to eq('right')
    end
  end

  describe '#move' do
    it 'moves the robot right' do
      allow(sprite).to receive(:x).and_return(0)
      allow(sprite).to receive(:x=).with(5)

      robot.set_direction('right')
      robot.move

      expect(robot.distance_travelled).to eq(5)
      expect(robot.movement_history).to eq(["right"])
    end

    it 'moves the robot left' do
      allow(sprite).to receive(:x).and_return(5)
      allow(sprite).to receive(:x=).with(0)

      robot.set_direction('left')
      robot.move

      expect(robot.distance_travelled).to eq(5)
      expect(robot.movement_history).to eq(["left"])
    end

    it 'moves the robot up' do
      allow(sprite).to receive(:y).and_return(5)
      allow(sprite).to receive(:y=).with(0)

      robot.set_direction('up')
      robot.move

      expect(robot.distance_travelled).to eq(5)
      expect(robot.movement_history).to eq(["up"])
    end

    it 'moves the robot down' do
      allow(sprite).to receive(:y).and_return(0)
      allow(sprite).to receive(:y=).with(5)

      robot.set_direction('down')
      robot.move

      expect(robot.distance_travelled).to eq(5)
      expect(robot.movement_history).to eq(["down"])
    end

    it 'keeps the robot still' do
      allow(sprite).to receive(:x).and_return(0)
      allow(sprite).to receive(:y).and_return(0)

      robot.set_direction('still')
      robot.move

      expect(robot.distance_travelled).to eq(0)
      expect(robot.movement_history).to eq(["still"])
    end
  end

  describe '#display' do
    it 'displays the robot going up' do
      robot.set_direction("up")
      expect(sprite).to receive(:play).with(animation: :up_down, loop: :true)

      robot.display
    end
    it 'displays the robot going down' do
      robot.set_direction("down")
      expect(sprite).to receive(:play).with(animation: :up_down, loop: :true)

      robot.display
    end
    it 'displays the robot going left' do
      robot.set_direction("left")
      expect(sprite).to receive(:play).with(animation: :left_right, loop: :true)

      robot.display
    end
    it 'displays the robot going right' do
      robot.set_direction("right")
      expect(sprite).to receive(:play).with(animation: :left_right, loop: :true, flip: :horizontal)

      robot.display
    end
    it 'displays the robot staying still' do
      robot.set_direction("still")
      expect(sprite).to receive(:play).with(animation: :up_down, loop: :true)

      robot.display
    end
  end
end