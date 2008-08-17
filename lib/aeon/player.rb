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
  
  # Sets the table name for DataMapper, otherwise it would be 'aeon_players'.
  def default_storage_name
    'players'
  end
  
  
  
  # TODO: yeah, obviously storing passwords in plain text is a bad idea. This
  # will change.
  def self.authenticate(name, password)
    self.first(:name => name, :password => password)
  end
  
  def client=(client)
    @client = client
  end

  def handle_input(data)
    data = data.strip.chomp
    return prompt if data.empty?
    execute_command(data)
    prompt
  end
  
  def execute_command(input)
    # Grab the first word as the command, the rest as the args  
    cmd, args = input.split(/\s/, 2)
    # find a list of matching commands
    matches = @@commands.grep(/#{cmd}/)
    unless matches.empty?
      send "cmd_#{matches.first}", args
    else
      display 'Huh?'
    end
  end


  
  # Class method for DSL-ish definition of commands.
  def self.command(command_name, &block)
    @@commands ||= []
    @@commands <<  command_name.to_s
    define_method("cmd_#{command_name.to_s}", &block)
  end
  
  command :who do
    display "Who List"
  end
  
  command :whoami do
    display "You are #{@name}."
  end
  
  command :ooc do |args|
    Aeon.world.players.each do |player|
      player.display "[OOC] TestPlayer: #{args}"
    end
  end
  
  
    
  # delegator to Aeon::Client#display
  def display(str)
    @client.display(str)
  end
  
  # delegator to Aeon::Client#prompt
  def prompt(str=nil)
    str ? @client.prompt(str) : @client.prompt("#{@name}> ")
  end

end
