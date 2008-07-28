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
  
  
  def animator=(connection)
    @animator = connection
  end
  
  def handle_input(data)
    @connection.display "You are TestPlayer."
  end

end
