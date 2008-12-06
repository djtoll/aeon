require 'pp'
require 'rubygems'
require 'dm-core'
require 'ruby-debug'
DataMapper.setup(:default, 'sqlite3::memory:')
require 'spec'

class Room
  include DataMapper::Resource
  
  
  #  
  # [r1] <-------------------> [r2] 
  #      ^ east_id   west_id ^
  #
  # [r1] <-------------------> [r3] 
  #      ^ east_id   west_id ^
  
  property :id, Integer, :serial => true
  property :name, String
  
  belongs_to :north, :class_name => "Room", :child_key => [:north_id]
  belongs_to :south, :class_name => "Room", :child_key => [:south_id]
  belongs_to :east,  :class_name => "Room", :child_key => [:east_id]
  belongs_to :west,  :class_name => "Room", :child_key => [:west_id]
  
  def east=(new_east)
    return east if east == new_east
    
    east.west = nil if east
    
    east_association.replace(new_east)
    new_east.west = self if new_east
  end
  
  def west=(new_west)
    return west if west == new_west
    
    west.east = nil if west
    
    west_association.replace(new_west)
    new_west.east = self if new_west
  end
  
  
  OPPOSITES = {
    'north' => 'south',
    'south' => 'north',
    'east'  => 'west',
    'west'  => 'east'
  }
  
  # %w(east west).each do |dir|
  #   opp = OPPOSITES[dir]
  #   class_eval <<-END
  #     def #{dir}=(new_dir)
  #       return #{dir} if #{dir} == #{opp}
  # 
  #       #{dir}.#{opp} = nil if #{dir}
  # 
  #       #{dir}_association.replace(new_dir)
  #       new_dir.#{opp} = self if new_dir
  #     end
  #   END
  # end
end

# pp Room.methods - Object.methods
# pp Room.relationships

DataMapper.auto_migrate!
DataMapper.logger.set_log(STDOUT, :debug)

r1 = Room.create(:name => "Room 1 (West)")
r2 = Room.create(:name => "Room 2 (East)")
r3 = Room.create(:name => "Room 3 (Also east)")

debugger
r1.east = r2
r1.east = r3

r1.save


pp r1
pp r2
pp r3
