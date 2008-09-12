class Aeon::Room
  include DataMapper::Resource
  
  property :id,           Integer, :serial => true
  property :name,         String
  property :description,  Text
  
  property :north_id,     Integer
  property :east_id,      Integer
  property :south_id,     Integer
  property :west_id,      Integer
  
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
  has n, :characters
  
  # Override DM's table name, which would have been "aeon_rooms"
  @storage_names[:default] = "rooms"
  
  
  def self.load_rooms
    @@room_cache = {}
    Aeon::Room.all.each { |r| @@room_cache[r.id] = r }
  end
  
  attr_accessor_with_default :objects, []
  
  OPPOSITES = {
    :north => :south,
    :south => :north,
    :east  => :west,
    :west  => :east
  }
  
  # Set up a getter for each direction that returns the linked room.
  %w(north east south west).each do |direction|
    class_eval <<-EOF
      # Return the room linked to this room to the #{direction}.
      def #{direction}
        @#{direction} ||= (Aeon::Room.get(#{direction}_id) if #{direction}_id)
      end
    EOF
  end
  
  # Link this room to another room in the specified direction.
  #
  # FIXME: This feels a bit hackish, especially using instance_variable_set.
  # At the moment I can't really think of a cleaner solution. It would be nice
  # to be able to do this using DM's 1-to-1 associations, but attempts at that
  # have failed.
  def link_with(room, direction)
    return false if exits.include?(room)
    # First we set an instance variable with the name of the direction on both rooms.
    self.instance_variable_set("@#{direction}", room)
    room.instance_variable_set("@#{OPPOSITES[direction]}", self)
    # Ensure that both rooms have an ID so that we can make the linkage in the DB.
    self.save if self.new_record?
    room.save if room.new_record?
    # Then we set the <direction>_id of each room so the linkage can be persisted to the DB.
    self.update_attributes("#{direction}_id" => room.id)
    room.update_attributes("#{OPPOSITES[direction]}_id" => self.id)
  end
  
  # Returns rooms that this room is linked to as an array of room in the form of:
  #   [n, e, s, w]
  def exits
    [north, east, south, west]
  end

  def full_description
    str =  "#{name}\n"
    str << "#{description}\n"
    str << "#{objects.join(', ')}\n"
    str << "Exits: #{exits.compact.join(', ')}"
  end
  
end