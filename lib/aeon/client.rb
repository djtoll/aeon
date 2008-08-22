# This is the module which gets mixed into EventMachine::Connection when the
# server starts. EventMachine::Connection provides three hooks for us to
# override: post_init, receive_data, and unbind.

module Aeon::Client

  attr_reader :player
  
  # Called when the client connects
  def post_init
    @world     = Aeon.world
    @connector = Aeon::Connector.new(self, @world)
  end
  
  # Called when we receive data from the client
  def receive_data(data)
    # TODO: perhaps sanitize data here?
    # send_data(data.inspect)
    if @player
      @player.handle_input(data)
    else
      @connector.handle_input(data)  
    end
  end
  
  # Called when the client disconnects
  def unbind
    @world.disconnect(@player) if @player
  end
  
  
  # Logs a client into a player and tells the player to animate its character.
  #
  # TODO: this needs to check to see if the player is already logged in. If so
  # we need to let the player (and probably those in the same room) know.
  def login_to_player(player)
    @player = player
    
    @player.client = self
    @player.animate
    @world.connect(@player)
    display "Welcome to Aeon, #{@player.name}."
    @player.prompt
  end
  
  
  
  def prompt(str)
    send_data "\n#{str}"
  end
  
  def display(str)
    send_data "\n#{str}\n"
  end

end