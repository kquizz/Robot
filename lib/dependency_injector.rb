require 'ruby2d'
require_relative 'square_factory'
require_relative 'game_board'
require_relative 'robot'
require_relative 'square'
require_relative 'event_handler'
require_relative 'state/splash'
require_relative 'state/running'
require_relative 'state/won'
require_relative 'state/results'

class DependencyInjector
  def createGameBoard
     GameBoard.new(numSquares:   100,
                  window:        Window,
                  title:         "Robot",
                  width:         800,
                  height:        800,
                  gapPercent:    20,
                  robot:         Robot,
                  eventHandler:  EventHandler,
                  squareFactory: SquareFactory.new(Ruby2D::Square, Square),
                  text:          Ruby2D::Text,
                  sprite:        Ruby2D::Sprite,
                  line:          Ruby2D::Line,
                  state:         State,
                  splash:        State::Splash,
                  running:       State::Running,
                  won:           State::Won,
                  results:       State::Results)
  end
end