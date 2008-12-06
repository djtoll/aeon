class Aeon::Room
  include DataMapper::Resource
  
  property :id,           Integer, :serial => true
  property :name,         String
  property :description,  Text
  
  belongs_to :north, :class_name => "Room"
  belongs_to :south, :class_name => "Room"
  belongs_to :east,  :class_name => "Room"
  belongs_to :west,  :class_name => "Room"
  
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has n, :characters
  
  # Override DM's table name, which would have been "aeon_rooms"
  @storage_names[:default] = "rooms"
  
  attr_accessor_with_default :objects, []
  
  OPPOSITES = {
    :north => :south,
    :south => :north,
    :east  => :west,
    :west  => :east
  }
  
  # Returns the first room in the database or creates one on the spot called "The Void".
  def self.default_room
    Aeon::Room.first || 
      create(:name => "The Void", :description => "Vast emptiness surrounds you.") 
  end
  
  def link(direction, new_room)
    opposite = OPPOSITES[direction]
    eval <<-EVAL
      new_room.#{opposite}.#{direction} = nil if new_room.#{opposite}
      #{direction}.#{opposite} = nil if #{direction}

      self.#{direction} = new_room
      new_room.#{opposite} = self
    EVAL
  end
  
  # Returns array of rooms tis room is linked to in this order: [n, e, s, w]
  def exits
    [north, east, south, west]
  end
  
  def exit_list
    list = []
    list << "n" if north
    list << "e" if east
    list << "s" if south
    list << "w" if west
  end
  
  def orphaned?
    exits.compact.empty?
  end

  def full_description
    str =  "#{name}\n"
    str << "#{description}\n"
    str << "Objects: #{objects.join(', ')}\n"
    str << "Exits: #{exit_list}"
  end
  
end