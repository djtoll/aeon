class Aeon::Player
  include DataMapper::Resource

  property :id,   Integer, :serial => true
  property :name, String
end