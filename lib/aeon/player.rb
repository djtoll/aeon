class Aeon::Player
  include DataMapper::Resource

  property :id,         Integer, :serial => true
  property :name,       String
  property :password,   String
  property :created_at, DateTime
  property :updated_at, DateTime
  
  
  def self.authenticate(name, password)
    self.first(:name => name, :password => password)
  end

end
