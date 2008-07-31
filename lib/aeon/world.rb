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
  
end