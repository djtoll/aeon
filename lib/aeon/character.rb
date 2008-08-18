class Aeon::Character
  include DataMapper::Resource
  
  property :id,   Integer, :serial => true
  property :name, String
  
  belongs_to :player
  
  # Override DM's table name, which would have been "aeon_characters"
  @storage_names[:default] = "characters"
end