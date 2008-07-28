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
  
  
  def animator=(client)
    @animator = client
  end
  
  def handle_input(data)
    display "You are TestPlayer."
  end
  
  def display(str)
    @animator.display(str)
  end
  
  def prompt(str)
    @animator.prompt(str)
  end

end
