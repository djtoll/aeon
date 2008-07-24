# This is the module which gets mixed into EventMachine::Connection when the
# server starts. EventMachine::Connection provides three hooks for us to
# override: post_init, receive_data, and unbind.
module Aeon::ConnectionHandler
  # Called when the client connects
  def post_init
  #   @world  = Aeon.world
  #   @connector = Player::Connector.new(self)
  #   # @player = Player.login(self, @world)
  #   # @player = Player.new(self, @world)
  #   # @world.connect(@player)
  # rescue Exception => e
  #   Aeon.log.error(e)
  end
  
  # Called when we receive data from the client
  def receive_data(data)
  #   if @player
  #     @player.handle_input(data) 
  #   else
  #     @connector.handle_input(data)
  #     @player = @connector.player if @connector.logged_in?
  #   end
  # rescue Exception => e
  #   Aeon.log.error(e)
  end
  
  # Called when the client disconnects
  def unbind
  #   @world.disconnect(@player)
  # rescue Exception => e
  #   Aeon.log.error(e)
  end
  
  # Gets some info about the connection
  # def info
  #   Socket.unpack_sockaddr_in(get_peername)
  # end

end