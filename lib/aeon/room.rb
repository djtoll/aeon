class Aeon::Room
  include DataMapper::Resource
  
  property :id,           Integer, :serial => true
  property :name,         String
  property :description,  Text
  property :created_at,   DateTime
  property :updated_at,   DateTime
  
  # belongs_to :character
  
  # Override DM's table name, which would have been "aeon_rooms"
  @storage_names[:default] = "rooms"
  
end