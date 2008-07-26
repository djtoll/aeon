# Takes new connections and logs them into a Player
class Aeon::Connector
  attr_reader :player
  
  def initialize(connection)
    @connection = connection
    @connection.prompt("What is your name, wanderer?")
    @step = :enter_username
  end
  
  def handle_input(input)
    input = input.chomp
    case @step
    when :enter_username
      if player = Aeon::Player.first(:name => input)
        @connection.prompt("OK, give me a password for #{player.name}")
        @step = :enter_password
      end
    when :enter_password
    end
  end
  
end