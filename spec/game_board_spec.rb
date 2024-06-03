require 'rspec'
require_relative '../lib/game_board'

RSpec.describe GameBoard do
  let(:window) { instance_double("Window") }
  let(:text) { instance_double("Text") }
  let(:line) { instance_double("Line") }
  let(:square_factory) { instance_double("SquareFactory") }
  let(:robot_class) { class_double("Robot") }
  let(:robot_instance) { instance_double("Robot") }
  let(:splash) { instance_double("Splash") }
  let(:running) { instance_double("Running") }
  let(:won) { instance_double("Won") }
  let(:results) { instance_double("Results") }
  let(:state) { class_double("State") }
  let(:state_instance) { instance_double("State") }
  let(:event_handler) { class_double("EventHandler") }
  let(:sprite) { instance_double("Sprite") }

  let(:square1) { instance_double("Square") }
  let(:square2) { instance_double("Square") }
  let(:squares) { [square1, square2] }


  before do
    allow(window).to receive(:set)
    allow(window).to receive(:frames).and_return(0)
    allow(window).to receive(:show)
    allow(window).to receive(:update)
    allow(window).to receive(:close)
    allow(window).to receive(:fps).and_return(60)
    allow(window).to receive(:width).and_return(800)
    allow(window).to receive(:height).and_return(600)
    
    allow(state).to receive(:new).and_return(state_instance)
    allow(state_instance).to receive(:change_state)
    allow(state_instance).to receive(:run)
    allow(state_instance).to receive(:handle_event_key_down)
    allow(state_instance).to receive(:handle_event_key_up)

    allow(text).to receive(:new).and_return(text)
    allow(square_factory).to receive(:createSquares).and_return(squares)
    allow(robot_class).to receive(:new).and_return(robot_instance)
    allow(splash).to receive(:new).and_return(splash)
    allow(running).to receive(:new).and_return(running)
    allow(won).to receive(:new).and_return(won)
    allow(results).to receive(:new).and_return(results)
    allow(event_handler).to receive(:new).and_return(event_handler)
    allow(sprite).to receive(:new).and_return(sprite)

    allow(squares).to receive(:select).and_return([])
    allow(squares).to receive(:each)
  end

  subject(:game_board) do
    GameBoard.new(
      numSquares: 10,
      window: window,
      width: 800,
      height: 600,
      title: "Game Title",
      text: text,
      line: line,
      squareFactory: square_factory,
      gapPercent: 10,
      robot: robot_class,
      sprite: sprite,
      splash: splash,
      running: running,
      won: won,
      results: results,
      state: state,
      eventHandler: event_handler
    )
  end

  describe '#run' do
  it 'calls the update and show methods on window' do
    expect(window).to receive(:update).and_yield
    expect(window).to receive(:show)
    expect(state_instance).to receive(:run)
      game_board.run
    end
  end
  
  describe '#check_win_condition' do
    it 'calls the select method on squares' do
      expect(squares).to receive(:select).and_return([])
      expect(state_instance).to receive(:change_state).with(:Won)

      game_board.check_win_condition
    end
    it 'does not call change_state with :Won when select does not return an empty array' do
      expect(squares).to receive(:select).and_return([square1])
      expect(state_instance).not_to receive(:change_state).with(:Won)

      game_board.check_win_condition
    end
  end
  
  describe '#change_state' do
    it 'calls the change_state method on state' do
      expect(state_instance).to receive(:change_state)
      game_board.change_state(:Won)
    end
  end
  
  describe '#check_collisions' do
  it 'calls the select method on squares' do

    collidingSquares = [square1, square2]
    allow(square1).to receive(:ord).and_return(1)
    allow(square2).to receive(:ord).and_return(2)
    expect(squares).to receive(:select).and_return(collidingSquares)
    expect(robot_instance).to receive(:currentSquare).twice.and_return(1)
    expect(robot_instance).to receive(:currentSquare=).with(2)
    expect(square1).to receive(:occupy)
    expect(square2).to receive(:enter)
    expect(square2).to receive(:occupy)

    game_board.check_collisions
    end
  end

  describe '#hide_all' do
    it 'calls the each method on squares' do
      sprite1 =  instance_double("Sprite")
      sprite2 = instance_double("Sprite")
      expect(squares).to receive(:each).and_yield(square1).and_yield(square2)
      expect(robot_instance).to receive(:sprite).and_return(sprite)
      expect(square1).to receive(:graphicSquare).and_return(sprite1)
      expect(square2).to receive(:graphicSquare).and_return(sprite2)
      expect(sprite1).to receive(:remove)
      expect(sprite2).to receive(:remove)
      expect(sprite).to receive(:remove)
      game_board.hide_all
    end
  end

  describe '#show_all' do
    it 'calls the each method on squares' do
      sprite1 =  instance_double("Sprite")
      sprite2 = instance_double("Sprite")
      expect(squares).to receive(:each).and_yield(square1).and_yield(square2)
      expect(robot_instance).to receive(:sprite).and_return(sprite)
      expect(square1).to receive(:graphicSquare).and_return(sprite1)
      expect(square2).to receive(:graphicSquare).and_return(sprite2)
      expect(sprite1).to receive(:add)
      expect(sprite2).to receive(:add)
      expect(sprite).to receive(:add)
      game_board.show_all
    end
  end
end