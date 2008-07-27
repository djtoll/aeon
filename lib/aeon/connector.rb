# Takes new connections and logs them into a Player
class Aeon::Connector
  attr_reader :player
  
  def initialize(connection)
    @connection = connection
    @connection.prompt("What is your name, wanderer? > ")
    @step = :enter_username
  end
  
  def handle_input(input)
    input = input.chomp
    case @step
    when :enter_username
      if Aeon::Player.first(:name => input)
        @player_name = input
        @connection.prompt("OK, give me a password for #{@player_name} > ")
        @step = :enter_password
      else
        @connection.display("No player found by that name.")
        @connection.prompt("What is your name, wanderer? > ")
      end
    when :enter_password
      if @player = Aeon::Player.authenticate(@player_name, input)
        @connection.display("Welcome to Aeon, #{@player.name}.")
        @step = :logged_in
      else
        @connection.prompt("What is your name, wanderer? > ")
        @step = :enter_username
      end
    end
  end
  
end