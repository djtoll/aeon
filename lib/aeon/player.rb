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
  
  # Setter for when something (the "animator") takes control of the Player. We
  # keep track of this so we know who to send responses to commands and
  # whatnot. This may change later when I start getting into multiple
  # observers on an object.
  def animator=(client)
    @animator = client
  end
  
  def handle_input(data)
    data = data.chomp
    send "cmd_#{data}"
    prompt
  end
  
  def cmd_whoami
    display "You are #{@name}."
  end
  
  # delegator to Aeon::Client#display
  def display(str)
    @animator.display(str)
  end
  
  # delegator to Aeon::Client#prompt
  def prompt(str=nil)
    str ? @animator.prompt(str) : @animator.prompt("#{@name}> ")
  end

end
