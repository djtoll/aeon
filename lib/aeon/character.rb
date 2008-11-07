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
  # def room
  #   room_association.nil? ? self.room = Aeon::Room.first : room_association
  # end
  
  def room=(new_room)
    raise "Tried to assign a nil room" if new_room.nil?
    self.room.characters.delete(self) if self.room
    new_room.characters << self
    room_association.replace(new_room)
  end
  
  def to_s
    "#{name}"
  end
  
  def say(str)
    room.objects.each do |obj|
      obj.animator.output(%{#{self.name} says, "#{str}"})
    end
  end
  
  def move(direction)
    self.room.objects.delete(self)
    @animator.output("You move #{direction}.")
    self.room = self.room.send(direction)
    self.room.objects << self
  end
  
  def look(target=room)
    
  end
end