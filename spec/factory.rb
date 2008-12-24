module Factory
  class << self
    
    def build(name, attrs={})
      send("#{name}_factory", attrs)
    end
  
    def create(name, attrs={})
      obj = build(name, attrs)
      obj.save
      obj
    end
  
  
    def player_factory(attrs)
      player = Aeon::Player.new({
        :name      => "Player1",
        :password  => "secret"
      }.merge!(attrs))
    
      player.character = Factory.build(:character, :name => player.name)
    
      player
    end
  
    def character_factory(attrs)
      Aeon::Character.new({
        :name      => "Player1"
      }.merge!(attrs))
    end
    
  end
end
