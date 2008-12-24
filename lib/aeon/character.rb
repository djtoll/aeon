module Aeon
  class Character
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
      set_room(room || Aeon::Room.default_room)
      self
    end
  
    def become_deanimated
      @animator = nil
      save
    end
  
    def say(str)
      room.objects.each do |obj|
        obj.display(%{#{name} says, "#{str}"})
      end
    end
  
    def move(direction)
      # TODO: encapsulate all of this display stuff into an Event class?
      if destination = room.send(direction)
        old_room = room
        
        display("You move #{direction}.")
        
        destination.objects.each do |obj|
          obj.display("#{name} enters from the #{Aeon::Room::OPPOSITES[direction]}.")
        end
        
        set_room(destination)
        
        old_room.objects.each do |obj|
          obj.display("#{name} exits to the #{direction}.")
        end
      else
        display("Alas, you cannot go that way.")
      end
    end
    
    def set_room(new_room)
      raise "Tried to assign a nil room" unless new_room
      return room if room == new_room
      
      room.objects.delete(self) if room
      update_attributes(:room => new_room)
      new_room.objects << self
      
      display(new_room.full_description)
      new_room
    end
  
    def look(target=room)
    
    end
  
    def display(msg)
      @animator.display(msg) if @animator
    end
  end
end