# The Player class acts as an interface between the human player and the MUD
# character that he/she controls. Later I'm betting that I'll abstract a lot
# of these methods into some kind of base class for any controllable world
# object.

class Aeon::Player
  include DataMapper::Resource

  property :id,         Integer, :serial => true
  property :name,       String
  property :password,   String
  property :created_at, DateTime
  property :updated_at, DateTime  
  
  # TODO: yeah, obviously storing passwords in plain text is a bad idea. This
  # will change.
  def self.authenticate(name, password)
    self.first(:name => name, :password => password)
  end
  
  def self.command(command_name, &block)
    @@commands ||= []
    @@commands <<  command_name.to_s
    define_method("cmd_#{command_name.to_s}", &block)
  end
  
  # Setter for when something (the "animator") takes control of the Player. We
  # keep track of this so we know who to send responses to commands and
  # whatnot. This may change later when/if I start getting into multiple
  # "observers" on a world object.
  def animator=(client)
    @animator = client
    prompt
  end
  
  def handle_input(data)
    data = data.strip.chomp
    return prompt if data.empty?
    execute_command(data)
    prompt
  end
  
  def execute_command(cmd)
    matches = @@commands.grep(/#{cmd}/)
    unless matches.empty?
      send "cmd_#{matches.first}"
    else
      display 'Huh?'
    end
  end
  
  command :who do
    display "Who List"
  end
  
  command :whoami do
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
