class Aeon::World
  
  class NoWorldError < RuntimeError
    def message
      "Tried to access the current World instance when no World has been instantiated!"
    end
  end
  
  class << self
    attr_writer :current_instance
    
    def current_instance
      @current_instance or raise(NoWorldError)
    end
  end
  
  attr_reader   :players
  
  def initialize
    Aeon::World.current_instance = self
    @players = []
  end
  
  def add_player(player)
    @players << player
  end
  
  def remove_player(player)
    @players.delete(player)
  end
  
  # Broadcast output to all connected players.
  # TODO: Right now this is used for channels, but later channels will have a
  # subscription system. Obviously players shouldn't get DEBUG messages, etc.
  def broadcast(msg)
    @players.each { |p| p.display(msg) }
  end
  
end