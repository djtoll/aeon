module Aeon
  class Room
    include DataMapper::Resource
  
    property :id,           Integer, :serial => true
    property :name,         String
    property :description,  Text
    property :x,            Integer
    property :y,            Integer
    property :z,            Integer
    property :zone,         Integer
  
    belongs_to :north, :class_name => "Room", :child_key => [:north_id]
    belongs_to :south, :class_name => "Room", :child_key => [:south_id]
    belongs_to :east,  :class_name => "Room", :child_key => [:east_id]
    belongs_to :west,  :class_name => "Room", :child_key => [:west_id]
  
    property :created_at, DateTime
    property :updated_at, DateTime
  
    has n, :characters
  
    before :save, :set_coordinates
  
    # Override DM's table name, which would have been "aeon_rooms"
    @storage_names[:default] = "rooms"
  
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
    
    def self.find_by_geom(coords)
      first(
        :x    => coords[0], 
        :y    => coords[1], 
        :z    => (coords[2] || 0), 
        :zone => (coords[3] || 0)
      )
    end
  
    # Called after :save. Uses geom= to set the coordinates and raises an
    # error if a room exists at those coordinates already.
    def set_coordinates
      self.geom = geom
      raise "Room already at coordinates: (#{geom.join(', ')})" if Aeon::Room.first(:x => self.x, :y => self.y, :id.not => id)
    end
  
    # Returns coordinates an array: [x, y, z, zone]
    def geom
      [x, y, z, zone]
    end
  
    # Sets the coordinates given an array in the form of [x, y, z, zone].
    # Points that are nil will be defaulted to 0.
    def geom=(ary)
      self.x    = ary[0] || 0
      self.y    = ary[1] || 0
      self.z    = ary[2] || 0
      self.zone = ary[3] || 0
    end
  
    # Links a room to a new room in the specified direction. If a room already
    # exists in that direction, it creates the link and returns that room.
    def bulldoze(direction, attrs={})
      direction = direction.to_sym
      geom = case direction
        when :north
          [x, y+1, z, zone]
        when :east
          [x+1, y, z, zone]
        when :south
          [x, y-1, z, zone]
        when :west
          [x-1, y, z, zone]
        end
    
      if existing_room = Room.find_by_geom(geom)
        link existing_room
      else
        link Room.create( {:geom => geom}.merge(attrs) )
      end 
    end
  
    def link(new_room)
      create_link(new_room, direction_to(new_room))
    end
  
    def link_zones(new_room, direction)
      raise "Rooms are in the same zone!" if zone == new_room.zone
      create_link(new_room, direction)
    end
    
    
    # Destroys the link to the room in the specified direction.
    def sever(direction)
      opposite = OPPOSITES[direction]
      old_room = send(direction)
      
      old_room.update_attributes(opposite => nil) if old_room
      update_attributes(direction => nil)
    end
  
    # Given a room, returns the direction from this room to that room IF the
    # room is directly next to this one on the coordinate plane, otherwise
    # returns nil.
    def direction_to(room)
      difference = (Matrix[room.geom] - Matrix[geom]).to_a.first
    
      case difference
      when [ 0, 1, 0, zone]: :north
      when [ 1, 0, 0, zone]: :east
      when [ 0,-1, 0, zone]: :south
      when [-1, 0, 0, zone]: :west
      when [ 0, 0, 1, zone]: :up
      when [ 0, 0,-1, zone]: :down
      end
    end
    
    
    def draw_map(width=5, height=5)
      rows = []
      rows << "+" + ("-" * width) + "+"
      
      xbounds = x-(width/2)..x+(width/2)
      ybounds = y-(height/2)..y+(height/2)
      
      rooms = {}
      Aeon::Room.all(:x => xbounds, :y => ybounds, :z => z, :zone => zone).each do |r|
        rooms[[r.x, r.y]] = r
      end
      
      ybounds.to_a.reverse.each do |pointy|
        row = '|'
        xbounds.each do |pointx|
          if room = rooms[[pointx,pointy]]
            room == self ? row << "o" : row << room.glyph
          else
            row << " "
          end
        end
        rows << row + "|"
      end
      
      rows << "+" + ("-" * width) + "+"
      rows.join("\n") + "\n"
    end

    def glyph
      " ".on_green
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
      list
    end
  
    def orphaned?
      exits.compact.empty?
    end
    
    
    
    def objects
      @objects ||= []
    end

    require 'colored'

    def full_description
      str =  "#{name}\n".bold
      str << "#{description}\n\n"
      str << "#{objects.join(', ')}\n"
      str << "Exits: [#{exit_list.join(', ')}]".cyan
    end
    
    
    private
    
    # Creates a link between two rooms in the specified direction.
    def create_link(new_room, direction)
      raise "Rooms must be saved before calling link"   unless id && new_room.id
      
      opposite = OPPOSITES[direction]
      
      transaction do
        sever(direction)
        update_attributes(direction => new_room)
        send(direction).update_attributes(opposite => self)
      end
      
      new_room
    end
    
  end
end