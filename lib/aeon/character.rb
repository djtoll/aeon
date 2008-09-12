class Aeon::Character
  include DataMapper::Resource
  
  property :id,   Integer, :serial => true
  property :name, String
  
  belongs_to :player
  belongs_to :room
  
  # Override DM's table name, which would have been "aeon_characters"
  @storage_names[:default] = "characters"

  attr_accessor :animator
  
  # Reader for the Character's associated Room.
  # This prevents the room association from being nil by defaulting it to the
  # first room in the database.
  #
  # FIXME: This sucks, I think.
  def room
    if room_association.nil? 
      room = Aeon::Room.get(1)
    end
    room_association
  end
  
  def to_s
    "#{name}"
  end
  
  def say(str)
    @animator.display(%{#{self.name} says, "#{str}"})
  end
  
  def move(direction)
    self.room.objects.delete(self)
    @animator.display("You move #{direction}.")
    self.room = self.room.send(direction)
    self.room.objects << self
  end
  
  def look(target=self.room)
    
  end
end