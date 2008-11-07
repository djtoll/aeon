require 'pp'
require 'rubygems'
require 'dm-core'
DataMapper.setup(:default, 'sqlite3::memory:')

class Character
  include DataMapper::Resource
  
  property   :id, Integer, :serial => true
  
  belongs_to :room

  def room=(new_room)
    self.room.characters.delete(self) if self.room
    new_room.characters << self unless new_room.nil?
    room_association.replace(new_room)
  end
  
end

class Room
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  
  has n, :characters
  
  # def initialize
  #   @characters = []
  # end
end

DataMapper.auto_migrate!
DataMapper.logger.set_log(STDOUT, :debug)






c  = Character.create
c2 = Character.create
r  = Room.create

c.room = r
c2.room = r

puts "       Character's room is:  #{c.inspect}"
puts "Second Character's room is:  #{c2.inspect}"
puts "       Room has characters:  #{r.characters.inspect}"

puts
puts

# r.save
# c.save
# c2.save
# r.reload

puts
puts

puts "       Character's room is:  #{c.inspect}"
puts "Second Character's room is:  #{c2.inspect}"
puts "       Room has characters:  #{r.characters.inspect}"
