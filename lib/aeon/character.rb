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
    room_association.nil? ? self.room = Aeon::Room.first : room_association
  end
  
  def say(str)
    @animator.display("#{self.name} says, \"#{str}\"")
  end
  
end