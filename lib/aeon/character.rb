class Aeon::Character
  include DataMapper::Resource
  
  property :id,   Integer, :serial => true
  property :name, String
  
  belongs_to :player
  belongs_to :room
  
  attr_reader :animator
  
  # Override DM's table name, which would have been "aeon_characters"
  @storage_names[:default] = "characters"
  
  def to_s
    "#{name}"
  end
  
  # Animate this character with the passed animator.
  # If the character has no room, its room is set to the default room.
  def become_animated(animator)
    @animator = animator
    self.room ||= Aeon::Room.default_room
    self
  end
  
  def become_deanimated
    @animator = nil
    save
  end
  
  def say(str)
    room.objects.each do |obj|
      obj.display(%{#{self.name} says, "#{str}"})
    end
  end
  
  def move(direction)
    room.objects.delete(self)
    display("You move #{direction}.")
    move_to room.send(direction)
  end
  
  def move_to(new_room)
    raise "Tried to assign a nil room" if new_room.nil?
    room.objects.delete(self)
    room = new_room
    new_room.objects << self
    display(room.full_description)
  end
  
  def look(target=room)
    
  end
  
  def display(msg)
    @animator.display(msg)
  end
end