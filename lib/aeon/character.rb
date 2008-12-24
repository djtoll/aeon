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
      to_room %{#{name} says, "#{str}"}, 
              %{You say, "#{str}"}
    end
  
    def move(direction)
      if destination = room.send(direction)
        to_room "#{name} moves to the #{direction}.", 
                "You move #{direction}."
                
        set_room(destination)
        
        to_room "#{name} enters from the #{Room::OPPOSITES[direction]}."
      else
        display("Alas, you cannot go that way.")
      end
    end
    
    def set_room(new_room)
      raise "Tried to assign a nil room" unless new_room
      
      room.objects.delete(self) if room
      update_attributes(:room => new_room) unless room == new_room
      new_room.objects << self
      
      display(new_room.full_description)
      
      new_room
    end
  
    def look(target=room)
      display(target.full_description)
    end
    
    def to_room(to_others, to_self=nil)
      Event.new :instigator => self,
                :target     => room,
                :message    => to_others,
                :to_self    => to_self
    end
  
    def display(msg)
      @animator.display(msg) if @animator
    end
  end
end