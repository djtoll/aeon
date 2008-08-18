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
  
  has 1, :character
  
  # Creates an associated Character with a new player unless assigned manually.
  before :create do
    self.character = Aeon::Character.new(:name => self.name) unless self.character
  end
  
  # Override DM's table name, which would have been "aeon_players"
  @storage_names[:default] = "players"
  
  
  # TODO: yeah, obviously storing passwords in plain text is a bad idea. This
  # will change.
  def self.authenticate(name, password)
    self.first(:name => name, :password => password)
  end
  
  # Setter called when a Client logs into this Player.
  def client=(client)
    @client = client
  end

  # Entry point for input from the Client. Do some cleanup on the input and
  # react to it.
  def handle_input(data)
    data = data.strip.chomp
    return prompt if data.empty?
    execute_command(data)
  end
  
  # Searches the list of commands for a matching one and executes it.
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
    msg =  "Online Players:\n"
    msg << "---------------\n"
    msg << Aeon.world.players.inject('') {|memo, p| memo << "#{p.name}\n"}
    display msg
  end
  
  command :whoami do
    display "You are #{@name}."
  end
  
  command :ooc do |args|
    Aeon.world.players.each do |player|
      player.display "[OOC] TestPlayer: #{args}"
    end
  end
  
  command :quit do
    display "Goodbye!", false
    @client.close_connection_after_writing
  end
  
  
    
  # Delegator to Aeon::Client#display
  # We also reprompt after each display unless told otherwise
  def display(str, reprompt=true)
    @client.display(str)
    prompt if reprompt
  end
  
  # Delegator to Aeon::Client#prompt
  def prompt(str=nil)
    str ? @client.prompt(str) : @client.prompt("#{@name}> ")
  end

end
