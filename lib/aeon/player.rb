class Aeon::Player
  include DataMapper::Resource

  property :id,         Integer, :serial => true
  property :name,       String
  property :password,   String
  property :created_at, DateTime
  property :updated_at, DateTime
  
  
  def authenticate(name, password)
    @authenticated = true if name == self.name && password == self.password
  end
  
  def authenticated?
    @authenticated ||= false
  end
end
