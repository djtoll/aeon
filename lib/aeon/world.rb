class Aeon::World
  attr_accessor :players
  
  def initialize
    @players = []
  end
  
  def connect(player)
    @players << player
  end
  
  def disconnect(player)
    @players.delete(player)
  end
  
  # Broadcast output to all connected players.
  # TODO: Right now this is used for channels, but later channels will have a
  # subscription system. Obviously players shouldn't get DEBUG messages, etc.
  def broadcast(msg)
    @players.each { |p| p.display(msg) }
  end
  
end