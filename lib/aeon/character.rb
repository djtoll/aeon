class Aeon::Character
  include DataMapper::Resource
  
  property :id,   Integer, :serial => true
  property :name, String
  
  belongs_to :player
  belongs_to :room
  
  # Override DM's table name, which would have been "aeon_characters"
  @storage_names[:default] = "characters"

  attr_accessor :animator
  
  # Returns the character's associated room. If the character's room is nil
  # for some reason, defaults to the first room in the database.
  def room
    room_association.nil? ? Aeon::Room.first : room_association
    # room_association || Aeon::Room.first # odd...
  end
  
  def get(foo)
    debugger
    foo
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