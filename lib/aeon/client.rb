# This is the module which gets mixed into EventMachine::Connection when the
# server starts. EventMachine::Connection provides three hooks for us to
# override: post_init, receive_data, and unbind.

module Aeon::Client
  
  def initialize(*args)
    super(*args)
  end
  
  # Called when the client connects
  def post_init
    @connector = Aeon::Connector.new(self)
  end
  
  # Called when we receive data from the client
  def receive_data(data)
    # TODO: perhaps sanitize data here?
    if @player
      @player.handle_input(data)
    else
      @connector.handle_input(data)  
    end
  end
  
  # Called when the client disconnects
  def unbind
    
  end
  
  
  
  def animate(player)
    player.animator = self
    @player = player
  end
    
  def prompt(str)
    send_data "\n#{str}"
  end
  
  def display(str)
    send_data "\n#{str}\n"
  end

end