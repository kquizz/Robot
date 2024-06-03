# Robot

Guide a Robot along a 10x10 grid of squares. They light up when you step on one!

Light up all squares to win!

Stick around after you win to see some interesting statistics about your game.

## File Structure

- [`lib/dependency_injector.rb`]: Injects the dependencies and default values. Creates a `GameBoard` instance with all its dependencies.
- [`lib/event_handler.rb`]: Initalizes the event handling
- [`lib/game_board.rb`]: Defines the `GameBoard` class. It's responsible for the game logic, including creating squares, checking collisions, and hiding all squares.
- [`lib/robot.rb`]: Defines the `Robot` class. It controls the Robot, sprite animation and movement.
- [`lib/run.rb`]: Starts the program!
- [`lib/square.rb`]: Defines a square.
- [`lib/square_factory.rb`]: Creates squares.
- [`lib/state/state.rb`]: Defines the state machine that controls running, event handling, and changing states
- [`lib/state/splash.rb`]: Defines the splash screen state
- [`lib/state/running.rb`]: Defines the game playing state
- [`lib/state/won.rb`]: Defines the end game state
- [`lib/state/results.rb`]: Defines the displaying results state
- [`spec/*`]: Holds the specs for relevant files

## How to Run

ruby lib/run.rb

## Dependencies

`gem install ruby2d`

`gem install rspec`

## Testing

rspec

## Contributing

Please don't

## License

GNU GPLv3
