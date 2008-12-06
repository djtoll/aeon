class Aeon::Character
  include DataMapper::Resource
  
  property :id,   Integer, :serial => true
  property :name, String
  
  belongs_to :player
  belongs_to :room
  
  # Override DM's table name, which would have been "aeon_characters"
  @storage_names[:default] = "characters"

  attr_accessor :animator
  
  def to_s
    "#{name}"
  end
  
  def say(str)
    room.objects.each do |obj|
      obj.animator.display(%{#{self.name} says, "#{str}"})
    end
  end
  
  def move(direction)
    room.objects.delete(self)
    @animator.display("You move #{direction}.")
    move_to room.send(direction)
  end
  
  def move_to(new_room)
    raise "Tried to assign a nil room" if new_room.nil?
    room.objects.delete(self)
    room = new_room
    new_room.objects << self
    @animator.display(room.full_description)
  end
  
  def look(target=room)
    
  end
end